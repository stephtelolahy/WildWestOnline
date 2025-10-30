//
//  CardEffectReducer.swift
//
//  Created by Hugues Telolahy on 30/10/2024.
//
// swiftlint:disable file_length force_unwrapping

extension Card.EffectName {
    func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
        try reducer.reduce(action, state: state)
    }
}

private extension Card.EffectName {
    protocol Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State
    }

    var reducer: Reducer {
        switch self {
        case .preparePlay: PreparePlay()
        case .draw: Draw()
        case .drawDeck: DrawDeck()
        case .drawDiscard: DrawDiscard()
        case .drawDiscovered: DrawDiscovered()
        case .discover: Discover()
        case .discardHand: DiscardHand()
        case .discardInPlay: DiscardInPlay()
        case .heal: Heal()
        case .damage: Damage()
        case .choose: Choose()
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
        case .setWeapon: SetWeapon()
        case .setPlayLimitPerTurn: SetPlayLimitPerTurn()
        case .increaseMagnifying: IncreaseMagnifying()
        case .increaseRemoteness: IncreaseRemoteness()
        case .setMaxHealth: fatalError("Unexpected to dispatch setMaxHealth")
        case .setHandLimit: fatalError("Unexpected to dispatch setHandLimit")
        case .setDrawCards: fatalError("Unexpected to dispatch setDrawCards")
        }
    }

    struct Draw: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            var state = state
            let card = try state.popDeck()
            state.discard.insert(card, at: 0)
            return state
        }
    }

    struct DrawDeck: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let target = action.targetedPlayer!

            var state = state
            let card = try state.popDeck()
            state[keyPath: \.players[target]!.hand].append(card)
            return state
        }
    }

    struct DrawDiscard: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let target = action.targetedPlayer!

            var state = state
            let card = try state.popDiscard()
            state[keyPath: \.players[target]!.hand].append(card)
            return state
        }
    }

    struct DrawDiscovered: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let target = action.targetedPlayer!
            let card = action.targetedCard!

            guard let discoverIndex = state.discovered.firstIndex(of: card) else {
                fatalError("Card \(card) not discovered")
            }

            guard let deckIndex = state.deck.firstIndex(of: card) else {
                fatalError("Card \(card) not in deck")
            }

            var state = state
            state.deck.remove(at: deckIndex)
            state.discovered.remove(at: discoverIndex)
            state[keyPath: \.players[target]!.hand].append(card)
            return state
        }
    }

    struct Discover: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
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
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let card = action.playedCard
            let cardName = Card.extractName(from: card)
            let cardObj = state.cards.get(cardName)

            let onPreparePlay = cardObj.effects.filter { $0.trigger == .cardPrePlayed }
            guard onPreparePlay.isNotEmpty else {
                throw .cardNotPlayable(cardName)
            }

            let effects = onPreparePlay
                .map {
                    $0.toInstance(
                        withPlayer: action.sourcePlayer,
                        playedCard: action.playedCard,
                        triggeredBy: action,
                        targetedPlayer: NonStandardLogic.targetedPlayerForChildEffect($0.action, parentAction: action)
                    )
                }

            var state = state
            state.queue.insert(contentsOf: effects, at: 0)
            return state
        }
    }

    struct Play: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let player = action.sourcePlayer
            let card = action.playedCard
            var state = state

            state[keyPath: \.players[player]!.hand].removeAll { $0 == card }
            state.discard.insert(card, at: 0)

            let cardName = Card.extractName(from: card)
            let cardObj = state.cards.get(cardName)
            let effects = cardObj.effects
                .filter { $0.trigger == .cardPlayed }
                .map {
                    $0.toInstance(
                        withPlayer: action.sourcePlayer,
                        playedCard: action.playedCard,
                        triggeredBy: action,
                        targetedPlayer: NonStandardLogic.targetedPlayerForChildEffect($0.action, parentAction: action),
                        targetedCard: action.targetedCard
                    )
                }

            state.queue.insert(contentsOf: effects, at: 0)

            let playedThisTurn = state.playedThisTurn[cardName] ?? 0
            state.playedThisTurn[cardName] = playedThisTurn + 1

            return state
        }
    }

    struct Equip: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let player = action.sourcePlayer
            let card = action.playedCard

            var state = state

            // verify not already inPlay
            let cardName = Card.extractName(from: card)
            let playerObj = state.players.get(player)
            guard playerObj.inPlay.allSatisfy({ Card.extractName(from: $0) != cardName }) else {
                throw .cardAlreadyInPlay(cardName)
            }

            // put card on self's play
            state[keyPath: \.players[player]!.hand].removeAll { $0 == card }
            state[keyPath: \.players[player]!.inPlay].append(card)

            return state
        }
    }

    struct Handicap: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let target = action.targetedPlayer!
            let player = action.sourcePlayer
            let card = action.playedCard

            var state = state

            // verify not already inPlay
            let cardName = Card.extractName(from: card)
            let targetObj = state.players.get(target)
            guard targetObj.inPlay.allSatisfy({ Card.extractName(from: $0) != cardName }) else {
                throw .cardAlreadyInPlay(cardName)
            }

            // put card on target's play
            state[keyPath: \.players[player]!.hand].removeAll { $0 == card }
            state[keyPath: \.players[target]!.inPlay].append(card)

            return state
        }
    }

    struct Heal: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let player = action.targetedPlayer!
            let amount = action.amount!

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
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let player = action.targetedPlayer!
            let card = action.targetedCard!

            var state = state
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
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let player = action.targetedPlayer!
            let card = action.targetedCard!

            var state = state
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
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let selection = action.chosenOption!

            guard let nextAction = state.queue.first,
                  let selector = nextAction.selectors.first,
                  case let .chooseOne(element, prompt, prevSelection) = selector,
                  let choice = prompt,
                  choice.options.map(\.label).contains(selection),
                  prevSelection == nil else {
                fatalError("Unexpected choose action")
            }

            var state = state
            var updatedAction = nextAction
            updatedAction.selectors[0] = .chooseOne(element, prompt: prompt, selection: selection)
            state.queue[0] = updatedAction

            return state
        }
    }

    struct StealHand: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let target = action.targetedPlayer!
            let card = action.targetedCard!
            let player = action.sourcePlayer

            var state = state
            let playerObj = state.players.get(target)
            guard playerObj.hand.contains(card) else {
                fatalError("Card \(card) not in hand of \(target)")
            }

            state[keyPath: \.players[target]!.hand].removeAll { $0 == card }
            state[keyPath: \.players[player]!.hand].append(card)

            return state
        }
    }

    struct StealInPlay: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let target = action.targetedPlayer!
            let card = action.targetedCard!
            let player = action.sourcePlayer

            let playerObj = state.players.get(target)
            guard playerObj.inPlay.contains(card) else {
                fatalError("Card \(card) not inPlay of \(target)")
            }

            var state = state
            state[keyPath: \.players[target]!.inPlay].removeAll { $0 == card }
            state[keyPath: \.players[player]!.hand].append(card)

            return state
        }
    }

    struct PassInPlay: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let target = action.targetedPlayer!
            let card = action.targetedCard!
            let player = action.sourcePlayer

            let playerObj = state.players.get(player)
            guard playerObj.inPlay.contains(card) else {
                fatalError("Card \(card) not inPlay of \(target)")
            }

            var state = state
            state[keyPath: \.players[player]!.inPlay].removeAll { $0 == card }
            state[keyPath: \.players[target]!.inPlay].append(card)

            return state
        }
    }

    struct Shoot: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            var state = state
            let damage = GameFeature.Action(
                name: .damage,
                sourcePlayer: action.sourcePlayer,
                playedCard: action.playedCard,
                triggeredBy: [action],
                targetedPlayer: action.targetedPlayer,
                amount: 1
            )
            state.queue.insert(damage, at: 0)
            return state
        }
    }

    struct CounterShoot: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            var state = state

            guard let damageIndex = state.queue.firstIndex(where: {
                $0.triggeredBy.first?.name == .shoot && $0.name == .damage && $0.targetedPlayer == action.targetedPlayer
            }) else {
                fatalError("No pending shoot effect found")
            }

            state.queue.remove(at: damageIndex)

            state.queue.removeAll { $0.triggeredBy.first?.name == .shoot && $0.name == .counterShot && $0.targetedPlayer == action.targetedPlayer }

            return state
        }
    }

    struct Damage: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let player = action.targetedPlayer!
            let amount = action.amount!

            var state = state
            state[keyPath: \.players[player]!.health] -= amount
            return state
        }
    }

    struct EndTurn: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            var state = state
            if let current = state.turn {
                state.queue.removeAll { $0.sourcePlayer == current && $0.playedCard != action.playedCard }
            }
            state.turn = nil
            return state
        }
    }

    struct StartTurn: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            var state = state
            state.turn = action.targetedPlayer
            state.playedThisTurn = [:]
            return state
        }
    }

    struct Queue: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let children = action.nestedEffects!

            var state = state
            state.queue.insert(contentsOf: children, at: 0)
            return state
        }
    }

    struct Eliminate: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            var state = state
            state.playOrder.removeAll { $0 == action.targetedPlayer }
            state.queue.removeAll { $0.sourcePlayer == action.targetedPlayer }
            return state
        }
    }

    struct EndGame: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            var state = state
            state.isOver = true
            return state
        }
    }

    struct Activate: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let target = action.targetedPlayer!
            let cards = action.affectedCards!

            var state = state
            state.active = [target: cards]
            return state
        }
    }

    struct SetWeapon: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let target = action.targetedPlayer!
            let weapon = action.amount!

            var state = state
            state[keyPath: \.players[target]!.weapon] = weapon
            return state
        }
    }

    struct SetPlayLimitPerTurn: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let target = action.targetedPlayer!
            let amountPerTurn = action.amountPerTurn!

            var state = state
            state[keyPath: \.players[target]!.playLimitPerTurn] = amountPerTurn
            return state
        }
    }

    struct IncreaseMagnifying: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let target = action.targetedPlayer!
            let amount = action.amount!

            var state = state
            state[keyPath: \.players[target]!.magnifying] += amount
            return state
        }
    }

    struct IncreaseRemoteness: Reducer {
        func reduce(_ action: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> GameFeature.State {
            let target = action.targetedPlayer!
            let amount = action.amount!

            var state = state
            state[keyPath: \.players[target]!.remoteness] += amount
            return state
        }
    }
}

private extension GameFeature.State {
    /// Draw the top card from the deck
    /// As soon as the draw pile is empty,
    /// shuffle the discard pile to create a new playing deck.
    mutating func popDeck() throws(Card.PlayError) -> String {
        if deck.isEmpty {
            try resetDeck()
        }

        return deck.remove(at: 0)
    }

    mutating func resetDeck() throws(Card.PlayError) {
        let minDiscardedCards = 2
        guard discard.count >= minDiscardedCards else {
            throw .insufficientDeck
        }

        let cards = discard
        discard = Array(cards.prefix(1))
        deck.append(contentsOf: Array(cards.dropFirst()))
    }

    mutating func popDiscard() throws(Card.PlayError) -> String {
        if discard.isEmpty {
            throw .insufficientDiscard
        }

        return discard.remove(at: 0)
    }
}
