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
            .damage: Damage(),
            .discard: Discard(),
            .steal: Steal(),
            .shoot: Shoot(),
            .endTurn: EndTurn(),
            .startTurn: StartTurn(),
            .group: Group()
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
            state[keyPath: \.players[payload.target]!.hand].append(card)
            return state
        }
    }

    struct DrawDiscard: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            var state = state
            let card = try state.popDiscard()
            state[keyPath: \.players[payload.target]!.hand].append(card)
            return state
        }
    }

    struct DrawDiscovered: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let card = payload.card else {
                fatalError("Missing payload parameter card")
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
            state[keyPath: \.players[payload.target]!.hand].append(card)
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
                fatalError("Missing payload parameter card")
            }

            let cardName = Card.extractName(from: card)

            guard let cardObject = state.cards[cardName] else {
                fatalError("Card \(cardName) not found")
            }

            guard cardObject.onPlay.isNotEmpty else {
                throw .cardNotPlayable(cardName)
            }

            for playReq in cardObject.canPlay {
                try playReq.match(state)
            }

            var state = state

            let onPlay = cardObject.onPlay
                .map {
                    GameAction(
                        kind: $0.action,
                        payload: .init(
                            actor: payload.target,
                            target: payload.target,
                            selectors: $0.selectors
                        )
                    )
                }
            state.queue.insert(contentsOf: onPlay, at: 0)

            let playedThisTurn = state.playedThisTurn[cardName] ?? 0
            state.playedThisTurn[cardName] = playedThisTurn + 1

            let playerObj = state.players.get(payload.target)
            if playerObj.hand.contains(card) {
                state[keyPath: \.players[payload.target]!.hand].removeAll { $0 == card }
                state.discard.insert(card, at: 0)
            } else if playerObj.abilities.contains(card) {
                // do nothing
            } else {
                fatalError("Unexpected play \(card)")
            }

            return state
        }
    }

    struct Heal: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let amount = payload.amount else {
                fatalError("Missing payload parameter amount")
            }

            let player = payload.target
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
                fatalError("Missing payload parameter card")
            }

            var state = state
            let player = payload.target
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
                fatalError("Missing payload parameter selection")
            }

            guard let nextAction = state.queue.first,
                  let selector = nextAction.payload.selectors.first,
                  case let .chooseOne(element, resolved, prevSelection) = selector,
                  let choice = resolved,
                  choice.options.map(\.label).contains(selection),
                  prevSelection == nil else {
                fatalError("Unexpected choose action")
            }

            var state = state
            var updatedAction = nextAction
            let updatedSelector = ActionSelector.chooseOne(element, resolved: resolved, selection: selection)
            updatedAction.payload.selectors[0] = updatedSelector
            state.queue[0] = updatedAction

            return state
        }
    }

    struct Steal: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let card = payload.card else {
                fatalError("Missing payload parameter card")
            }

            let actor = payload.actor
            let target = payload.target
            let targetObj = state.players.get(target)

            var state = state
            if targetObj.hand.contains(card) {
                state[keyPath: \.players[target]!.hand].removeAll { $0 == card }
                state[keyPath: \.players[actor]!.hand].append(card)
            } else if targetObj.inPlay.contains(card) {
                state[keyPath: \.players[target]!.inPlay].removeAll { $0 == card }
                state[keyPath: \.players[actor]!.hand].append(card)
            } else {
                fatalError("Card \(card) not owned by \(target)")
            }

            return state
        }
    }

    struct Shoot: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            var state = state
            let effect = GameAction(
                kind: .damage,
                payload: .init(
                    actor: payload.actor,
                    target: payload.target,
                    amount: 1, // TODO: set damage amount from payload
                    selectors: [
                        .chooseOne(.eventuallyCounterCard([.counterShot]))
                    ]
                )
            )
            state.queue.insert(effect, at: 0)
            return state
        }
    }

    struct Damage: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let amount = payload.amount else {
                fatalError("Missing payload parameter amount")
            }

            var state = state
            state[keyPath: \.players[payload.target]!.health] -= amount
            return state
        }
    }

    struct EndTurn: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            var state = state
            state.turn = nil
            return state
        }
    }

    struct StartTurn: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            var state = state
            state.turn = payload.target
            return state
        }
    }

    struct Group: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            var state = state
            state.queue.insert(contentsOf: payload.children, at: 0)
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
        deck.append(contentsOf: Array(cards.dropFirst()))
    }

    mutating func popDiscard() throws(GameError) -> String {
        if discard.isEmpty {
            throw .discardIsEmpty
        }

        return discard.remove(at: 0)
    }
}