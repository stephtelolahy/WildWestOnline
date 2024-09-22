//
//  FieldReducer.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//

import Redux

public extension FieldState {
    // swiftlint:disable:next closure_body_length
    static let reducer: Reducer<Self> = { state, action in
        switch action {
        case GameAction.playEquipment:
            try equipReducer(state, action)

        case GameAction.playHandicap:
            try handicapReducer(state, action)

        case GameAction.undiscover:
            try undiscoverReducer(state, action)

        case GameAction.drawDeck:
            try drawDeckReducer(state, action)

        case GameAction.discardHand:
            try discardHandReducer(state, action)

        case GameAction.drawDiscovered:
            try drawDiscoveredReducer(state, action)

        case GameAction.drawDiscard:
            try drawDiscardReducer(state, action)

        case GameAction.stealInPlay:
            try drawInPlayReducer(state, action)

        case GameAction.passInPlay:
            try passInPlayReducer(state, action)

        case GameAction.discover:
            try discoverReducer(state, action)

        case GameAction.draw:
            try drawReducer(state, action)

        case GameAction.playBrown:
            try discardPlayedReducer(state, action)

        case GameAction.discardInPlay:
            try discardInPlayReducer(state, action)

        case GameAction.stealHand:
            try drawHandReducer(state, action)

        default:
            state
        }
    }
}

private extension FieldState {
    static let equipReducer: Reducer<Self> = { state, action in
        guard case let GameAction.playEquipment(card, player) = action else {
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

    static let handicapReducer: Reducer<Self> = { state, action in
        guard case let GameAction.playHandicap(card, target, player) = action else {
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

    static let undiscoverReducer: Reducer<Self> = { state, action in
        guard case GameAction.undiscover = action else {
            fatalError("unexpected")
        }

        var state = state
        state.discovered = []
        return state
    }

    static let drawHandReducer: Reducer<Self> = { state, action in
        guard case let GameAction.stealHand(card, target, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.hand[target]]?.remove(card)
        state[keyPath: \Self.hand[player]]?.append(card)
        return state
    }

    static let drawDeckReducer: Reducer<Self> = { state, action in
        guard case let GameAction.drawDeck(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        let card = try state.popDeck()
        state[keyPath: \Self.hand[player]]?.append(card)
        return state
    }

    static let drawDiscoveredReducer: Reducer<Self> = { state, action in
        guard case let GameAction.drawDiscovered(card, player) = action else {
            fatalError("unexpected")
        }

        var state = state

        guard let deckIndex = state.deck.firstIndex(of: card) else {
            fatalError("card \(card) not found in deck")
        }

        guard let discoverIndex = state.discovered.firstIndex(of: card) else {
            fatalError("card \(card) not found in discovered")
        }

        state.deck.remove(at: deckIndex)
        state.discovered.remove(at: discoverIndex)
        state[keyPath: \Self.hand[player]]?.append(card)
        return state
    }

    static let drawDiscardReducer: Reducer<Self> = { state, action in
        guard case let GameAction.drawDiscard(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        let card = try state.popDiscard()
        state[keyPath: \Self.hand[player]]?.append(card)
        return state
    }

    static let drawInPlayReducer: Reducer<Self> = { state, action in
        guard case let GameAction.stealInPlay(card, target, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.inPlay[target]]?.remove(card)
        state[keyPath: \Self.hand[player]]?.append(card)
        return state
    }

    static let passInPlayReducer: Reducer<Self> = { state, action in
        guard case let GameAction.passInPlay(card, target, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.inPlay[player]]?.remove(card)
        state[keyPath: \Self.inPlay[target]]?.append(card)
        return state
    }

    static let discoverReducer: Reducer<Self> = { state, action in
        guard case let GameAction.discover(amount) = action else {
            fatalError("unexpected")
        }

        var state = state
        if state.deck.count < amount {
            try state.resetDeck()
        }

        state.discovered = Array(state.deck.prefix(amount))

        return state
    }

    static let drawReducer: Reducer<Self> = { state, action in
        guard case GameAction.draw = action else {
            fatalError("unexpected")
        }

        var state = state
        let card = try state.popDeck()
        state.discard.insert(card, at: 0)
        return state
    }

    static let discardHandReducer: Reducer<Self> = { state, action in
        guard case let GameAction.discardHand(card, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.hand[player]]?.remove(card)
        state.discard.insert(card, at: 0)
        return state
    }

    static let discardPlayedReducer: Reducer<Self> = { state, action in
        guard case let GameAction.playBrown(card, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.hand[player]]?.remove(card)
        state.discard.insert(card, at: 0)
        return state
    }

    static let discardInPlayReducer: Reducer<Self> = { state, action in
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
            try resetDeck()
        }

        return deck.remove(at: 0)
    }

    mutating func resetDeck() throws {
        let minDiscardedCards = 2
        guard discard.count >= minDiscardedCards else {
            throw Error.deckIsEmpty
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
