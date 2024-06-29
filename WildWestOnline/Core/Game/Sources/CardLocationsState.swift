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
        case GameAction.drawHand:
            try drawHandReducer(state, action)

        case GameAction.discardHand:
            try discardHandReducer(state, action)

        case GameAction.discardPlayed:
            try discardPlayedReducer(state, action)

        default:
            state
        }
    }
}

private extension CardLocationsState {
    static let drawHandReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.drawHand(card, target, player) = action else {
            fatalError("unexpected")
        }
        var state = state
        state[keyPath: \CardLocationsState.hand[target]]?.remove(card)
        state[keyPath: \CardLocationsState.hand[player]]?.append(card)
        return state
    }

    static let discardHandReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.discardHand(card, player) = action else {
            fatalError("unexpected")
        }
        var state = state
        state[keyPath: \CardLocationsState.hand[player]]?.remove(card)
        state.discard.insert(card, at: 0)
        return state
    }

    static let discardPlayedReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.discardPlayed(card, player) = action else {
            fatalError("unexpected")
        }
        var state = state
        state[keyPath: \CardLocationsState.hand[player]]?.remove(card)
        state.discard.insert(card, at: 0)
        return state
    }
}
