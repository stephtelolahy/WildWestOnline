//
//  GameReducer.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//

import Redux

public extension GameState {
    static let reducer: Reducer<Self> = { state, action in
        var state = state
        state.players = try PlayersState.reducer(state.players, action)
        state.round = try RoundState.reducer(state.round, action)
        state.sequence = try SequenceState.reducer(state, action).sequence

        if let action = action as? GameAction {
            state = try action.reduce(state: state)
        }

        return state
    }
}

public extension GameState {
    enum Error: Swift.Error, Equatable {
        /// Already having same card in play
        case cardAlreadyInPlay(String)

        /// Expected non empty deck
        case deckIsEmpty

        /// Expected non empty discard pile
        case discardIsEmpty
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
        case .playAbility(let string, let player):
            fatalError()
        case .heal(let int, let player):
            fatalError()
        case .damage(let int, let player):
            fatalError()
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
        case .discardInPlay(let string, let player):
            fatalError()
        case .passInPlay(let card, let target, let player):
            PassInPlayReducer(card: card, target: target, player: player)
        case .draw:
            DrawReducer()
        case .showLastHand(let player):
            fatalError()
        case .discover(let amount):
            DiscoverReducer(amount: amount)
        case .drawDiscovered(let card, let player):
            DrawDiscoveredReducer(card: card, player: player)
        case .undiscover:
            UndiscoverReducer()
        case .startTurn(let player):
            fatalError()
        case .endTurn(let player):
            fatalError()
        case .eliminate(let player):
            fatalError()
        case .setAttribute(let playerAttribute, let value, let player):
            fatalError()
        case .endGame(let winner):
            fatalError()
        case .activate(let array, let player):
            fatalError()
        case .chooseOne(let choiceType, let options, let player):
            fatalError()
        case .preparePlay(let string, let player):
            fatalError()
        case .prepareChoose(let string, let player):
            fatalError()
        case .prepareEffect(let resolvingEffect):
            fatalError()
        case .queue(let array):
            fatalError()
        }
    }
}

protocol GameReducer {
    func reduce(state: GameState) throws -> GameState
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
