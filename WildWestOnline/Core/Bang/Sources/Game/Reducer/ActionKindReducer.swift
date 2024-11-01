//
//  ActionKindReducer.swift
//  Bang
//
//  Created by Hugues Telolahy on 30/10/2024.
//

extension GameAction.Kind {
    func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
        try reducer.reduce(state, payload)
    }
}

private extension GameAction.Kind {
    protocol Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState
    }

    var reducer: Reducer {
        let dict: [GameAction.Kind: Reducer] = [
            .play: Play(),
            .choose: Choose(),
            .draw: Draw(),
            .drawDeck: DrawDeck(),
            .drawDiscard: DrawDiscard(),
            .drawDiscovered: DrawDiscovered(),
            .discover: Discover(),
            .heal: Heal(),
            .discard: Discard()
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
            state[keyPath: \.players[payload.actor]!.hand].removeAll { $0 == card }
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

    struct Heal: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let amount = payload.amount else {
                fatalError("Missing amount from payload")
            }

            let player = payload.actor
            var playerObj = state.players.get(player)
            let maxHealth = playerObj.maxHealth
            guard playerObj.health < maxHealth else {
                throw GameError.playerAlreadyMaxHealth(player)
            }

            playerObj.health = min(playerObj.health + amount, maxHealth)
            var state = state
            state.players[player] = playerObj
            return state
        }
    }

    struct Discard: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let card = payload.card else {
                fatalError("Missing card from payload")
            }

            var state = state
            let player = payload.actor
            let playerObj = state.players.get(player)

            if playerObj.hand.contains(card) {
                state[keyPath: \.players[player]!.hand].removeAll { $0 == card }
                state.discard.insert(card, at: 0)
            } else if playerObj.inPlay.contains(card) {
                state[keyPath: \.players[player]!.inPlay].removeAll { $0 == card }
                state.discard.insert(card, at: 0)
            } else {
                fatalError("Card \(card) not owned by \(player)")
            }

            return state
        }
    }

    struct Choose: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let selection = payload.selection else {
                fatalError("Missing selection from payload")
            }

            guard let nextAction = state.queue.first,
                  let selector = nextAction.payload.selectors.first,
                  case .chooseOne(let chooseOneDetails) = selector,
                  chooseOneDetails.options.contains(selection),
                  chooseOneDetails.selection == nil else {
                fatalError("Unexpected choose action")
            }

            var state = state
            var updatedAction = nextAction
            var updatedDetails = chooseOneDetails
            updatedDetails.selection = selection
            let updatedSelector = ActionSelector.chooseOne(updatedDetails)
            updatedAction.payload.selectors[0] = updatedSelector
            state.queue[0] = updatedAction

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
