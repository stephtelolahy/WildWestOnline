//
//  FieldReducer.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//

private extension FieldState {
    
    static let passInPlayReducer: Reducer<Self> = { state, action in
        guard case let GameAction.passInPlay(card, target, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self.inPlay[player]]?.remove(card)
        state[keyPath: \Self.inPlay[target]]?.append(card)
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
