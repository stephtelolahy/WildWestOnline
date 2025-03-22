//
//  ActionNameReducer.swift
//
//  Created by Hugues Telolahy on 30/10/2024.
//
// swiftlint:disable file_length

extension GameAction.Name {
    func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
        try reducer.reduce(state, payload)
    }
}

private extension GameAction.Name {
    protocol Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState
    }

    var reducer: Reducer {
        switch self {
        case .preparePlay: PreparePlay()
        case .draw: Draw()
        case .drawDeck: DrawDeck()
        case .drawDiscard: DrawDiscard()
        case .drawDiscovered: DrawDiscovered()
        case .discover: Discover()
        case .discard: fatalError()
        case .discardHand: DiscardHand()
        case .discardInPlay: DiscardInPlay()
        case .heal: Heal()
        case .damage: Damage()
        case .choose: Choose()
        case .steal: fatalError()
        case .stealHand: StealHand()
        case .stealInPlay: StealInPlay()
        case .passInPlay: PassInPlay()
        case .shoot: Shoot()
        case .counterShot: CounterShoot()
        case .endTurn: EndTurn()
        case .startTurn: StartTurn()
        case .queue: Queue()
        case .eliminate: Eliminate()
        case .endGame: EndGame()
        case .activate: Activate()
        case .play: Play()
        case .equip: Equip()
        case .handicap: Handicap()
        case .setMaxHealth: fatalError()
        case .setHandLimit: fatalError()
        case .setWeapon: SetWeapon()
        case .increaseMagnifying: IncreaseMagnifying()
        case .increaseRemoteness: IncreaseRemoteness()
        case .setPlayLimitPerTurn: SetPlayLimitPerTurn()
        case .setDrawCards: fatalError()
        }
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

    struct PreparePlay: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            let cardName = Card.extractName(from: payload.source)
            let cardObj = state.cards.get(cardName)
            guard cardObj.onPlay.isNotEmpty else {
                throw .cardNotPlayable(cardName)
            }

            for playReq in cardObj.canPlay {
                guard playReq.match(actor: payload.actor, state: state) else {
                    throw .noReq(playReq)
                }
            }

            var state = state

            let onPlay = cardObj.onPlay
                .map {
                    GameAction(
                        name: $0.name,
                        payload: .init(
                            actor: payload.actor,
                            source: payload.source,
                            target: payload.actor
                        ),
                        selectors: $0.selectors
                    )
                }
            state.queue.insert(contentsOf: onPlay, at: 0)

            let playedThisTurn = state.playedThisTurn[cardName] ?? 0
            state.playedThisTurn[cardName] = playedThisTurn + 1

            return state
        }
    }

    struct Play: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let card = payload.card else {
                fatalError("Missing payload parameter card")
            }

            var state = state

            state[keyPath: \.players[payload.target]!.hand].removeAll { $0 == card }
            state.discard.insert(card, at: 0)

            return state
        }
    }

    struct Equip: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let card = payload.card else {
                fatalError("Missing payload parameter card")
            }

            var state = state

            // verify rule: not already inPlay
            let cardName = Card.extractName(from: card)
            let playerObj = state.players.get(payload.target)
            guard playerObj.inPlay.allSatisfy({ Card.extractName(from: $0) != cardName }) else {
                throw .cardAlreadyInPlay(cardName)
            }

            // put card on self's play
            state[keyPath: \.players[payload.target]!.hand].removeAll { $0 == card }
            state[keyPath: \.players[payload.target]!.inPlay].append(card)

            return state
        }
    }

    struct Handicap: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let card = payload.card else {
                fatalError("Missing payload parameter card")
            }

            var state = state

            // verify rule: not already inPlay
            let cardName = Card.extractName(from: card)
            let targetObj = state.players.get(payload.target)
            guard targetObj.inPlay.allSatisfy({ Card.extractName(from: $0) != cardName }) else {
                throw .cardAlreadyInPlay(cardName)
            }

            // put card on target's play
            state[keyPath: \.players[payload.actor]!.hand].removeAll { $0 == card }
            state[keyPath: \.players[payload.target]!.inPlay].append(card)

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
                throw .playerAlreadyMaxHealth(player)
            }

            playerObj.health = min(playerObj.health + amount, maxHealth)
            var state = state
            state.players[player] = playerObj
            return state
        }
    }

    struct DiscardHand: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let card = payload.card else {
                fatalError("Missing payload parameter card")
            }

            var state = state
            let player = payload.target
            let playerObj = state.players.get(player)

            guard playerObj.hand.contains(card) else {
                fatalError("Card \(card) not in hand of \(player)")
            }

            state[keyPath: \.players[player]!.hand].removeAll { $0 == card }
            state.discard.insert(card, at: 0)

            return state
        }
    }

    struct DiscardInPlay: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let card = payload.card else {
                fatalError("Missing payload parameter card")
            }

            var state = state
            let player = payload.target
            let playerObj = state.players.get(player)

            guard playerObj.inPlay.contains(card) else {
                fatalError("Card \(card) not inPlay of \(player)")
            }

            state[keyPath: \.players[player]!.inPlay].removeAll { $0 == card }
            state.discard.insert(card, at: 0)

            return state
        }
    }

    struct Choose: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let selection = payload.selection else {
                fatalError("Missing payload parameter selection")
            }

            guard let nextAction = state.queue.first,
                  let selector = nextAction.selectors.first,
                  case let .chooseOne(element, resolved, prevSelection) = selector,
                  let choice = resolved,
                  choice.options.map(\.label).contains(selection),
                  prevSelection == nil else {
                fatalError("Unexpected choose action")
            }

            var state = state
            var updatedAction = nextAction
            let updatedSelector = Card.Selector.chooseOne(element, resolved: resolved, selection: selection)
            updatedAction.selectors[0] = updatedSelector
            state.queue[0] = updatedAction

            return state
        }
    }

    struct StealHand: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let card = payload.card else {
                fatalError("Missing payload parameter card")
            }

            let actor = payload.actor
            let target = payload.target
            let playerObj = state.players.get(target)

            var state = state
            guard playerObj.hand.contains(card) else {
                fatalError("Card \(card) not in hand of \(target)")
            }

            state[keyPath: \.players[target]!.hand].removeAll { $0 == card }
            state[keyPath: \.players[actor]!.hand].append(card)

            return state
        }
    }

    struct StealInPlay: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let card = payload.card else {
                fatalError("Missing payload parameter card")
            }

            let actor = payload.actor
            let target = payload.target
            let playerObj = state.players.get(target)
            guard playerObj.inPlay.contains(card) else {
                fatalError("Card \(card) not inPlay of \(target)")
            }

            var state = state
            state[keyPath: \.players[target]!.inPlay].removeAll { $0 == card }
            state[keyPath: \.players[actor]!.hand].append(card)

            return state
        }
    }

    struct PassInPlay: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let card = payload.card else {
                fatalError("Missing payload parameter card")
            }

            let actor = payload.actor
            let target = payload.target
            let playerObj = state.players.get(actor)
            guard playerObj.inPlay.contains(card) else {
                fatalError("Card \(card) not inPlay of \(target)")
            }

            var state = state
            state[keyPath: \.players[actor]!.inPlay].removeAll { $0 == card }
            state[keyPath: \.players[target]!.inPlay].append(card)

            return state
        }
    }

    struct Shoot: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            var state = state
            let effect = GameAction(
                name: .damage,
                payload: .init(
                    actor: payload.actor,
                    source: payload.source,
                    target: payload.target,
                    amount: 1
                ),
                selectors: [.chooseOne(.eventuallyCounterCard([.counterShot]))]
            )
            state.queue.insert(effect, at: 0)
            return state
        }
    }

    struct CounterShoot: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            var state = state

            guard let nextAction = state.queue.first,
                  nextAction.name == .damage,
                  nextAction.payload.target == payload.target else {
                fatalError("Next action should be shoot effect")
            }

            state.queue.removeFirst()
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
            if let current = state.turn {
                state.queue.removeAll { $0.payload.actor == current && $0.payload.source != payload.source }
            }
            state.turn = nil
            return state
        }
    }

    struct StartTurn: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            var state = state
            state.turn = payload.target
            state.playedThisTurn = [:]
            return state
        }
    }

    struct Queue: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let children = payload.children else {
                fatalError("Missing payload parameter children")
            }

            var state = state
            state.queue.insert(contentsOf: children, at: 0)
            return state
        }
    }

    struct Eliminate: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            var state = state
            state.playOrder.removeAll { $0 == payload.target }
            state.queue.removeAll { $0.payload.actor == payload.target }
            return state
        }
    }

    struct EndGame: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            var state = state
            state.isOver = true
            return state
        }
    }

    struct Activate: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let cards = payload.cards else {
                fatalError("Missing payload parameter cards")
            }

            var state = state
            state.active = [payload.target: cards]
            return state
        }
    }

    struct SetWeapon: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let weapon = payload.amount else {
                fatalError("Missing payload parameter amount")
            }

            var state = state
            state[keyPath: \.players[payload.target]!.weapon] = weapon
            return state
        }
    }

    struct SetPlayLimitPerTurn: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let amountPerCard = payload.amountPerCard else {
                fatalError("Missing payload parameter amountPerCard")
            }

            var state = state
            state[keyPath: \.players[payload.target]!.playLimitPerTurn] = amountPerCard
            return state
        }
    }

    struct IncreaseMagnifying: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let amount = payload.amount else {
                fatalError("Missing payload parameter amount")
            }

            var state = state
            state[keyPath: \.players[payload.target]!.magnifying] += amount
            return state
        }
    }

    struct IncreaseRemoteness: Reducer {
        func reduce(_ state: GameState, _ payload: GameAction.Payload) throws(GameError) -> GameState {
            guard let amount = payload.amount else {
                fatalError("Missing payload parameter amount")
            }

            var state = state
            state[keyPath: \.players[payload.target]!.remoteness] += amount
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
            throw .insufficientDeck
        }

        let cards = discard
        discard = Array(cards.prefix(1))
        deck.append(contentsOf: Array(cards.dropFirst()))
    }

    mutating func popDiscard() throws(GameError) -> String {
        if discard.isEmpty {
            throw .insufficientDiscard
        }

        return discard.remove(at: 0)
    }
}
