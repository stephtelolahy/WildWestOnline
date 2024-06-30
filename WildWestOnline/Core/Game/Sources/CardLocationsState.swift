//
//  CardLocationsState.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 29/06/2024.
//

import Redux

public struct CardLocationsState: Equatable, Codable {
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

public extension CardLocationsState {
    static let reducer: ThrowingReducer<Self> = { state, action in
        switch action {
        case GameAction.equip:
            try equipReducer(state, action)

        case GameAction.drawHand:
            try drawHandReducer(state, action)

        case GameAction.discardHand:
            try discardHandReducer(state, action)

        case GameAction.discardPlayed:
            try discardPlayedReducer(state, action)

        case GameAction.discardInPlay:
            try discardInPlayReducer(state, action)

        default:
            state
        }
    }
}

private extension CardLocationsState {
    static let equipReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.equip(card, player) = action else {
            fatalError("unexpected")
        }

        // verify rule: not already inPlay
        let cardName = card.extractName()
        let playerInPlay = state.inPlay[player] ?? []
        guard playerInPlay.allSatisfy({ $0.extractName() != cardName }) else {
            throw GameError.cardAlreadyInPlay(cardName)
        }

        // put card on self's play
        var state = state
        state[keyPath: \Self.hand[player]]?.remove(card)
        state[keyPath: \Self.inPlay[player]]?.append(card)

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
