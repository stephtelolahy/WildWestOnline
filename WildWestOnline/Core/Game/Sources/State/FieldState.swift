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
    static let reducer: ThrowingReducer<Self> = { state, action in
        switch action {
        case GameAction.equip:
            try equipReducer(state, action)

        case GameAction.handicap:
            try handicapReducer(state, action)

        case GameAction.putBack:
            try putBackReducer(state, action)

        case GameAction.drawDeck:
            try drawDeckReducer(state, action)

        case GameAction.discardHand:
            try discardHandReducer(state, action)

        case GameAction.drawArena:
            try drawArenaReducer(state, action)

        case GameAction.drawDiscard:
            try drawDiscardReducer(state, action)

        case GameAction.drawInPlay:
            try drawInPlayReducer(state, action)

        case GameAction.passInPlay:
            try passInPlayReducer(state, action)

        case GameAction.discover:
            try discoverReducer(state, action)

        case GameAction.draw:
            try drawReducer(state, action)

        case GameAction.discardPlayed:
            try discardPlayedReducer(state, action)

        case GameAction.discardInPlay:
            try discardInPlayReducer(state, action)

        case GameAction.drawHand:
            try drawHandReducer(state, action)

        default:
            state
        }
    }
}

private extension FieldState {
    static let equipReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.equip(card, player) = action else {
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

    static let handicapReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.handicap(card, target, player) = action else {
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

    static let putBackReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.putBack(card, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.hand[player]]?.remove(card)
        state.deck.insert(card, at: 0)
        return state
    }

    static let drawHandReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.drawHand(card, target, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.hand[target]]?.remove(card)
        state[keyPath: \Self.hand[player]]?.append(card)
        return state
    }

    static let drawDeckReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.drawDeck(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        let card = try state.popDeck()
        state[keyPath: \Self.hand[player]]?.append(card)
        return state
    }

    static let drawArenaReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.drawArena(card, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.arena.remove(card)
        state[keyPath: \Self.hand[player]]?.append(card)
        return state
    }

    static let drawDiscardReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.drawDiscard(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        let card = try state.popDiscard()
        state[keyPath: \Self.hand[player]]?.append(card)
        return state
    }

    static let drawInPlayReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.drawInPlay(card, target, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.inPlay[target]]?.remove(card)
        state[keyPath: \Self.hand[player]]?.append(card)
        return state
    }

    static let passInPlayReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.passInPlay(card, target, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.inPlay[player]]?.remove(card)
        state[keyPath: \Self.inPlay[target]]?.append(card)
        return state
    }

    static let discoverReducer: ThrowingReducer<Self> = { state, action in
        guard case GameAction.discover = action else {
            fatalError("unexpected")
        }

        var state = state
        let card = try state.popDeck()
        state.arena.append(card)
        return state
    }

    static let drawReducer: ThrowingReducer<Self> = { state, action in
        guard case GameAction.draw = action else {
            fatalError("unexpected")
        }

        var state = state
        let card = try state.popDeck()
        state.discard.insert(card, at: 0)
        return state
    }

    static let discardHandReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.discardHand(card, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.hand[player]]?.remove(card)
        state.discard.insert(card, at: 0)
        return state
    }

    static let discardPlayedReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.discardPlayed(card, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.hand[player]]?.remove(card)
        state.discard.insert(card, at: 0)
        return state
    }

    static let discardInPlayReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.discardInPlay(card, player) = action else {
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
