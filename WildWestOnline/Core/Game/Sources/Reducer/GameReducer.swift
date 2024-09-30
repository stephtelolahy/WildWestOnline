//
//  GameReducer.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//
// swiftlint:disable vertical_whitespace_between_cases file_length

import Redux

public extension GameState {
    static let reducer: Reducer<Self> = { state, action in
        guard let action = action as? GameAction else {
            return state
        }

        var state = state
        state = try PrepareReducer(action: action).reduce(state: state)
        state = try action.reduce(state: state)
        return state
    }
}

public extension GameState {
    enum Error: Swift.Error, Equatable {
        case cardAlreadyInPlay(String)
        case deckIsEmpty
        case discardIsEmpty
        case playerAlreadyMaxHealth(String)
        case gameIsOver
        case unwaitedAction
        case cardNotPlayable(String)
        case noShootToCounter
    }
}

extension GameAction {
    func reduce(state: GameState) throws -> GameState {
        try reducer.reduce(state: state)
    }

    private var reducer: GameReducer {
        switch self {
        case .playBrown(let card, let player):
            PlayBrownReducer(card: card, player: player)
        case .playEquipment(let card, let player):
            PlayEquipmentReducer(card: card, player: player)
        case .playHandicap(let card, let target, let player):
            PlayHandicapReducer(card: card, player: player, target: target)
        case .playAbility(let card, let player):
            PlayAbilityReducer(card: card, player: player)
        case .heal(let amount, let player):
            HealReducer(amount: amount, player: player)
        case .damage(let amount, let player):
            DamageReducer(amount: amount, player: player)
        case .drawDeck(let player):
            DrawDeckReducer(player: player)
        case .drawDiscard(let player):
            DrawDiscardReducer(player: player)
        case .stealHand(let card, let target, let player):
            StealHandReducer(card: card, target: target, player: player)
        case .stealInPlay(let card, let target, let player):
            StealInPlayReducer(card: card, target: target, player: player)
        case .discardHand(let card, let player):
            DiscardHandReducer(card: card, player: player)
        case .discardInPlay(let card, let player):
            DiscardInPlayReducer(card: card, player: player)
        case .passInPlay(let card, let target, let player):
            PassInPlayReducer(card: card, target: target, player: player)
        case .draw:
            DrawReducer()
        case .showLastHand:
            DummyReducer()
        case .discover(let amount):
            DiscoverReducer(amount: amount)
        case .drawDiscovered(let card, let player):
            DrawDiscoveredReducer(card: card, player: player)
        case .undiscover:
            UndiscoverReducer()
        case .startTurn(let player):
            StartTurnReducer(player: player)
        case .endTurn(let player):
            EndTurnReducer(player: player)
        case .eliminate(let player):
            EliminateReducer(player: player)
        case .endGame(let winner):
            EndGameReducer(winner: winner)
        case .activate(let cards, let player):
            ActivateReducer(cards: cards, player: player)
        case .chooseOne(let choiceType, let options, let player):
            ChooseOneReducer(choiceType: choiceType, options: options, player: player)
        case .preparePlay(let card, let player):
            PreparePlayReducer(card: card, player: player)
        case .prepareChoose(let option, let player):
            PrepareChooseReducer(option: option, player: player)
        case .prepareEffect(let effect):
            PrepareEffectReducer(effect: effect)
        case .queue(let actions):
            QueueReducer(actions: actions)
        case .setMaginifying(let value, let player):
            fatalError()
        case .setWeapon(let value, let player):
            fatalError()
        case .setRemoteness(let value, let player):
            fatalError()
        }
    }
}

protocol GameReducer {
    func reduce(state: GameState) throws -> GameState
}

struct PrepareReducer: GameReducer {
    let action: GameAction

    func reduce(state: GameState) throws -> GameState {
        // Game is over
        if state.winner != nil {
            throw GameState.Error.gameIsOver
        }

        var state = state

        // Pending choice
        if let chooseOne = state.chooseOne.first {
            guard case let GameAction.prepareChoose(option, player) = action,
                  player == chooseOne.key,
                  chooseOne.value.options.contains(option) else {
                throw GameState.Error.unwaitedAction
            }

            state.chooseOne.removeValue(forKey: chooseOne.key)
            return state
        }

        // Active cards
        if let active = state.active.first {
            guard case let GameAction.preparePlay(card, player) = action,
                  player == active.key,
                  active.value.contains(card) else {
                throw GameState.Error.unwaitedAction
            }

            state.active.removeValue(forKey: active.key)
            return state
        }

        // Resolving sequence
        if state.queue.isNotEmpty,
           state.queue.first == action {
            state.queue.removeFirst()
        }

        return state
    }
}

struct PlayEquipmentReducer: GameReducer {
    let card: String
    let player: String

    func reduce(state: GameState) throws -> GameState {
        let playerObj = state.player(player)
        let cardName = card.extractName()
        guard playerObj.inPlay.allSatisfy({ $0.extractName() != cardName }) else {
            throw GameState.Error.cardAlreadyInPlay(cardName)
        }

        var state = state
        state[keyPath: \.players[player]!.hand].remove(card)
        state[keyPath: \.players[player]!.inPlay].append(card)
        return state
    }
}

struct PlayHandicapReducer: GameReducer {
    let card: String
    let player: String
    let target: String

    func reduce(state: GameState) throws -> GameState {
        let cardName = card.extractName()
        let targetInPlay = state.player(target).inPlay
        guard targetInPlay.allSatisfy({ $0.extractName() != cardName }) else {
            throw GameState.Error.cardAlreadyInPlay(cardName)
        }

        var state = state
        state[keyPath: \.players[player]!.hand].remove(card)
        state[keyPath: \.players[target]!.inPlay].append(card)

        return state
    }
}

struct DrawReducer: GameReducer {
    func reduce(state: GameState) throws -> GameState {
        var state = state
        let card = try state.popDeck()
        state.discard.insert(card, at: 0)
        return state
    }
}

struct DummyReducer: GameReducer {
    func reduce(state: GameState) throws -> GameState {
        state
    }
}

struct DiscoverReducer: GameReducer {
    let amount: Int

    func reduce(state: GameState) throws -> GameState {
        var state = state
        if state.deck.count < amount {
            try state.resetDeck()
        }

        state.discovered = Array(state.deck.prefix(amount))

        return state
    }
}

struct UndiscoverReducer: GameReducer {
    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.discovered = []
        return state
    }
}

struct DrawDiscoveredReducer: GameReducer {
    let card: String
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state

        guard let deckIndex = state.deck.firstIndex(of: card) else {
            fatalError("card \(card) not found in deck")
        }

        guard let discoverIndex = state.discovered.firstIndex(of: card) else {
            fatalError("card \(card) not found in discovered")
        }

        state.deck.remove(at: deckIndex)
        state.discovered.remove(at: discoverIndex)
        state[keyPath: \.players[player]!.hand].append(card)
        return state
    }
}

struct StealHandReducer: GameReducer {
    let card: String
    let target: String
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state[keyPath: \.players[target]!.hand].remove(card)
        state[keyPath: \.players[player]!.hand].append(card)
        return state
    }
}

struct StealInPlayReducer: GameReducer {
    let card: String
    let target: String
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state[keyPath: \.players[target]!.inPlay].remove(card)
        state[keyPath: \.players[player]!.hand].append(card)
        return state
    }
}

struct DrawDeckReducer: GameReducer {
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        let card = try state.popDeck()
        state[keyPath: \.players[player]!.hand].append(card)
        return state
    }
}

struct DrawDiscardReducer: GameReducer {
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        let card = try state.popDiscard()
        state[keyPath: \.players[player]!.hand].append(card)
        return state
    }
}

struct PassInPlayReducer: GameReducer {
    let card: String
    let target: String
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state[keyPath: \.players[player]!.inPlay].remove(card)
        state[keyPath: \.players[target]!.inPlay].append(card)
        return state
    }
}

struct DiscardHandReducer: GameReducer {
    let card: String
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state[keyPath: \.players[player]!.hand].remove(card)
        state.discard.insert(card, at: 0)
        return state
    }
}

struct DiscardInPlayReducer: GameReducer {
    let card: String
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state[keyPath: \.players[player]!.inPlay].remove(card)
        state.discard.insert(card, at: 0)
        return state
    }
}

struct PlayBrownReducer: GameReducer {
    let card: String
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state[keyPath: \.players[player]!.hand].remove(card)
        state.discard.insert(card, at: 0)
        return state
    }
}

struct PlayAbilityReducer: GameReducer {
    let card: String
    let player: String

    func reduce(state: GameState) throws -> GameState {
        state
    }
}

struct HealReducer: GameReducer {
    let amount: Int
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var playerObj = state.player(player)
        let maxHealth = playerObj.maxHealth
        guard playerObj.health < maxHealth else {
            throw GameState.Error.playerAlreadyMaxHealth(player)
        }

        playerObj.health = Swift.min(playerObj.health + amount, maxHealth)
        var state = state
        state.players[player] = playerObj
        return state
    }
}

struct DamageReducer: GameReducer {
    let amount: Int
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var playerObj = state.player(player)
        playerObj.health -= amount

        var state = state
        state.players[player] = playerObj
        return state
    }
}

struct StartTurnReducer: GameReducer {
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.turn = player
        state.turnPlayedBang = 0
        return state
    }
}

struct EndTurnReducer: GameReducer {
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.turn = nil
        return state
    }
}

struct EliminateReducer: GameReducer {
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.playOrder.removeAll { $0 == player }
        state.queue.removeAll { $0.isEffectTriggeredBy(player) }
        return state
    }
}

struct QueueReducer: GameReducer {
    let actions: [GameAction]

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.queue.insert(contentsOf: actions, at: 0)
        return state
    }
}

struct ActivateReducer: GameReducer {
    let cards: [String]
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.active[player] = cards
        return state
    }
}

struct ChooseOneReducer: GameReducer {
    let choiceType: ChoiceType
    let options: [String]
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.chooseOne[player] = ChooseOne(
            type: choiceType,
            options: options
        )
        return state
    }
}

struct EndGameReducer: GameReducer {
    let winner: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.winner = winner
        return state
    }
}

struct PreparePlayReducer: GameReducer {
    let card: String
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var cardName = card.extractName()
        guard let cardObj = state.cards[cardName] else {
            throw GameState.Error.cardNotPlayable(card)
        }

        let effects = cardObj.triggered.filter { $0.when == .played }
        guard effects.isNotEmpty else {
            throw GameState.Error.cardNotPlayable(card)
        }

        var state = state
        let children: [GameAction] = effects.map {
            .prepareEffect(
                .init(
                    action: $0.action,
                    card: card,
                    actor: player,
                    event: .preparePlay(card, player: player),
                    selectors: $0.selectors
                )
            )
        }
        state.queue.insert(contentsOf: children, at: 0)

        return state
    }
}

struct PrepareEffectReducer: GameReducer {
    let effect: ResolvingEffect

    func reduce(state: GameState) throws -> GameState {
        var state = state
        if effect.selectors.isEmpty {
            let resolved = try effect.action.resolve(effect)
            state.queue.insert(resolved, at: 0)
        } else {
            var effect = effect
            let selector = effect.selectors.remove(at: 0)
            let resolved = try selector
                .resolve(state: state, ctx: effect)
                .map(GameAction.prepareEffect)
            state.queue.insert(contentsOf: resolved, at: 0)
        }

        return state
    }
}

struct PrepareChooseReducer: GameReducer {
    let option: String
    let player: String

    func reduce(state: GameState) throws -> GameState {
        state
    }
}

private extension GameState {
    /// Draw the top card from the deck
    /// As soon as the draw pile is empty, shuffle the discard pile to create a new playing deck.
    mutating func popDeck() throws -> String {
        if deck.isEmpty {
            try resetDeck()
        }

        return deck.remove(at: 0)
    }

    mutating func resetDeck() throws {
        let minDiscardedCards = 2
        guard discard.count >= minDiscardedCards else {
            throw GameState.Error.deckIsEmpty
        }

        let cards = discard
        discard = Array(cards.prefix(1))
        deck = Array(cards.dropFirst())
    }

    mutating func popDiscard() throws -> String {
        if discard.isEmpty {
            throw Error.discardIsEmpty
        }

        return discard.remove(at: 0)
    }
}
