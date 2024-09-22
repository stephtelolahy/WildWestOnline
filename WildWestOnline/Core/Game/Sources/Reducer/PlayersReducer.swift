//
//  PlayersReducer.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//

import Redux

public extension PlayersState {
    static let reducer: Reducer<Self> = { state, action in
        switch action {
        case GameAction.heal:
            try healReducer(state, action)

        case GameAction.damage:
            try damageReducer(state, action)

        case GameAction.setAttribute:
            try setAttributeReducer(state, action)

        default:
            state
        }
    }
}

private extension PlayersState {
    static let healReducer: Reducer<Self> = { state, action in
        guard case let GameAction.heal(amount, player) = action else {
            fatalError("unexpected")
        }
        var playerObj = state.get(player)
        let maxHealth = playerObj.attributes.get(.maxHealth)

        guard playerObj.health < maxHealth else {
            throw Error.playerAlreadyMaxHealth(player)
        }

        playerObj.health = Swift.min(playerObj.health + amount, maxHealth)

        var state = state
        state[player] = playerObj
        return state
    }

    static let damageReducer: Reducer<Self> = { state, action in
        guard case let GameAction.damage(amount, player) = action else {
            fatalError("unexpected")
        }
        var playerObj = state.get(player)
        playerObj.health -= amount

        var state = state
        state[player] = playerObj
        return state
    }

    static let setAttributeReducer: Reducer<Self> = { state, action in
        guard case let GameAction.setAttribute(key, value, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self[player]]?.setValue(value, forAttribute: key)
        return state
    }
}

extension Player {
    mutating func setValue(_ value: Int?, forAttribute key: PlayerAttribute) {
        attributes[key] = value
    }
}
