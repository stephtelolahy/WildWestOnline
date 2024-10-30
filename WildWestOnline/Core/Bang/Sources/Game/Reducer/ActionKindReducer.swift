//
//  ActionKindReducer.swift
//  Bang
//
//  Created by Hugues Telolahy on 30/10/2024.
//

extension GameAction.Kind {
    func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
        return try reducer.reduce(state, payload)
    }
}

private extension GameAction.Kind {
    protocol Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState
    }

    var reducer: Reducer {
        let dict : [GameAction.Kind: Reducer] = [
            .draw: Draw(),
            .drawDeck: DrawDeck(),
            .drawDiscard: DrawDiscard(),
            .drawDiscovered: DrawDiscovered(),
            .discover: Discover(),
            .play: Play()
        ]

        guard let result = dict[self] else {
            fatalError("Missing reducer for \(self)")
        }

        return result
    }

    struct Draw: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            var state = state
            let card = try state.popDeck()
            state.discard.insert(card, at: 0)
            return state
        }
    }

    struct DrawDeck: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            var state = state
            let card = try state.popDeck()
            state[keyPath: \.players[payload.actor]!.hand].append(card)
            return state
        }
    }

    struct DrawDiscard: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            var state = state
            let card = try state.popDiscard()
            state[keyPath: \.players[payload.actor]!.hand].append(card)
            return state
        }
    }

    struct DrawDiscovered: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let card = payload.card else {
                fatalError("Missing card from payload")
            }

            guard let discoverIndex = state.discovered.firstIndex(of: card) else {
                fatalError("Card \(card) not discovered")
            }

            guard let deckIndex = state.deck.firstIndex(of: card) else {
                fatalError("Card \(card) not in deck")
            }

            var state = state
            state.deck.remove(at: deckIndex)
            state.discovered.remove(at: discoverIndex)
            state[keyPath: \.players[payload.actor]!.hand].append(card)
            return state
        }
    }

    struct Discover: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            var state = state
            let discoveredAmount = state.discovered.count
            if discoveredAmount >= state.deck.count {
                try state.resetDeck()
            }

            state.discovered.append(state.deck[discoveredAmount])
            return state
        }
    }

    struct Play: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let card = payload.card else {
                fatalError("Missing card from payload")
            }

            guard let cardObject = state.cards[card] else {
                fatalError("Card \(card) not found")
            }

            var state = state
            state[keyPath: \.players[payload.actor]!.hand].removeAll(where: { $0 == card})
            state.discard.insert(card, at: 0)

            let onPlay = cardObject.onPlay
                .map {
                    GameAction(
                        kind: $0.action,
                        payload: .init(
                            actor: payload.actor,
                            selectors: $0.selectors
                        )
                    )
                }
            state.queue.insert(contentsOf: onPlay, at: 0)

            return state
        }
    }
}

private extension GameState {
    /// Draw the top card from the deck
    /// As soon as the draw pile is empty,
    /// shuffle the discard pile to create a new playing deck.
    mutating func popDeck() throws(GameError) -> String {
        if deck.isEmpty {
            try resetDeck()
        }

        return deck.remove(at: 0)
    }

    mutating func resetDeck() throws(GameError) {
        let minDiscardedCards = 2
        guard discard.count >= minDiscardedCards else {
            throw .deckIsEmpty
        }

        let cards = discard
        discard = Array(cards.prefix(1))
        deck = Array(cards.dropFirst())
    }

    mutating func popDiscard() throws(GameError) -> String {
        if discard.isEmpty {
            throw .discardIsEmpty
        }

        return discard.remove(at: 0)
    }
}
