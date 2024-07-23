//
//  FieldState.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 29/06/2024.
//

import Redux

public struct FieldState: Equatable, Codable {
    /// Deck
    public var deck: [String]

    /// Discard pile
    public var discard: [String]

    /// Cards shop
    public var arena: [String]

    /// Hand cards
    public var hand: [String: [String]]

    /// In play cards
    public var inPlay: [String: [String]]
}

public extension FieldState {
    enum Error: Swift.Error, Equatable {
        /// Already having same card in play
        case cardAlreadyInPlay(String)

        /// Expected non empty deck
        case deckIsEmpty

        /// Expected non empty discard pile
        case discardIsEmpty
    }
}

public extension FieldState {
    // swiftlint:disable:next closure_body_length
    static let reducer: Reducer<Self, GameAction> = { state, action in
        switch action {
        case .equip:
            try equipReducer(state, action)

        case .handicap:
            try handicapReducer(state, action)

        case .putBack:
            try putBackReducer(state, action)

        case .drawDeck:
            try drawDeckReducer(state, action)

        case .discardHand:
            try discardHandReducer(state, action)

        case .drawArena:
            try drawArenaReducer(state, action)

        case .drawDiscard:
            try drawDiscardReducer(state, action)

        case .drawInPlay:
            try drawInPlayReducer(state, action)

        case .passInPlay:
            try passInPlayReducer(state, action)

        case .discover:
            try discoverReducer(state, action)

        case .draw:
            try drawReducer(state, action)

        case .discardPlayed:
            try discardPlayedReducer(state, action)

        case .discardInPlay:
            try discardInPlayReducer(state, action)

        case .drawHand:
            try drawHandReducer(state, action)

        default:
            state
        }
    }
}

private extension FieldState {
    static let equipReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .equip(card, player) = action else {
            fatalError("unexpected")
        }

        // verify rule: not already inPlay
        let cardName = card.extractName()
        let playerInPlay = state.inPlay[player] ?? []
        guard playerInPlay.allSatisfy({ $0.extractName() != cardName }) else {
            throw Error.cardAlreadyInPlay(cardName)
        }

        // put card on self's play
        var state = state
        state[keyPath: \Self.hand[player]]?.remove(card)
        state[keyPath: \Self.inPlay[player]]?.append(card)

        return state
    }

    static let handicapReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .handicap(card, target, player) = action else {
            fatalError("unexpected")
        }

        // verify rule: not already inPlay
        let cardName = card.extractName()
        let targetInPlay = state.inPlay[target] ?? []
        guard targetInPlay.allSatisfy({ $0.extractName() != cardName }) else {
            throw Error.cardAlreadyInPlay(cardName)
        }

        // put card on other's play
        var state = state
        state[keyPath: \Self.hand[player]]?.remove(card)
        state[keyPath: \Self.inPlay[target]]?.append(card)

        return state
    }

    static let putBackReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .putBack(card, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.hand[player]]?.remove(card)
        state.deck.insert(card, at: 0)
        return state
    }

    static let drawHandReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .drawHand(card, target, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.hand[target]]?.remove(card)
        state[keyPath: \Self.hand[player]]?.append(card)
        return state
    }

    static let drawDeckReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .drawDeck(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        let card = try state.popDeck()
        state[keyPath: \Self.hand[player]]?.append(card)
        return state
    }

    static let drawArenaReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .drawArena(card, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.arena.remove(card)
        state[keyPath: \Self.hand[player]]?.append(card)
        return state
    }

    static let drawDiscardReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .drawDiscard(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        let card = try state.popDiscard()
        state[keyPath: \Self.hand[player]]?.append(card)
        return state
    }

    static let drawInPlayReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .drawInPlay(card, target, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.inPlay[target]]?.remove(card)
        state[keyPath: \Self.hand[player]]?.append(card)
        return state
    }

    static let passInPlayReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .passInPlay(card, target, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.inPlay[player]]?.remove(card)
        state[keyPath: \Self.inPlay[target]]?.append(card)
        return state
    }

    static let discoverReducer: Reducer<Self, GameAction> = { state, action in
        guard case .discover = action else {
            fatalError("unexpected")
        }

        var state = state
        let card = try state.popDeck()
        state.arena.append(card)
        return state
    }

    static let drawReducer: Reducer<Self, GameAction> = { state, action in
        guard case .draw = action else {
            fatalError("unexpected")
        }

        var state = state
        let card = try state.popDeck()
        state.discard.insert(card, at: 0)
        return state
    }

    static let discardHandReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .discardHand(card, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.hand[player]]?.remove(card)
        state.discard.insert(card, at: 0)
        return state
    }

    static let discardPlayedReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .discardPlayed(card, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.hand[player]]?.remove(card)
        state.discard.insert(card, at: 0)
        return state
    }

    static let discardInPlayReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .discardInPlay(card, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.inPlay[player]]?.remove(card)
        state.discard.insert(card, at: 0)
        return state
    }
}

private extension FieldState {
    /// Draw the top card from the deck
    /// As soon as the draw pile is empty, shuffle the discard pile to create a new playing deck.
    mutating func popDeck() throws -> String {
        if deck.isEmpty {
            let minDiscardedCards = 2
            guard discard.count >= minDiscardedCards else {
                throw Error.deckIsEmpty
            }

            let cards = discard
            discard = Array(cards.prefix(1))
            deck = Array(cards.dropFirst())
        }

        return deck.remove(at: 0)
    }

    mutating func popDiscard() throws -> String {
        if discard.isEmpty {
            throw Error.discardIsEmpty
        }

        return discard.remove(at: 0)
    }
}
