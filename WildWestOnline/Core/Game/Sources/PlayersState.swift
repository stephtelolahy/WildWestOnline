//
//  PlayersState.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 24/06/2024.
//
// swiftlint:disable type_contents_order

import Foundation
import Redux

public struct PlayersState: Equatable, Codable {
    var content: [String: Player]

    public struct Player: Equatable, Codable {
        /// Life points
        public var health: Int

        /// Figure name. Determining initial attributes
        public let figure: String

        /// Current abilities
        public let abilities: Set<String>

        /// Current attributes
        public var attributes: [String: Int]
    }
}

public extension PlayersState {
    static let reducer: ThrowingReducer<Self> = { state, action in
        switch action {
        case GameAction.heal:
            try healReducer(state, action)

        case GameAction.damage:
            try damageReducer(state, action)

        default:
            state
        }
    }
}

private extension PlayersState {
    static let healReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.heal(amount, player) = action else {
            fatalError("unexpected")
        }
        var playerObj = state.content.get(player)
        let maxHealth = playerObj.attributes.get(.maxHealth)

        guard playerObj.health < maxHealth else {
            throw GameError.playerAlreadyMaxHealth(player)
        }

        playerObj.health = min(playerObj.health + amount, maxHealth)

        var state = state
        state.content[player] = playerObj
        return state
    }

    static let damageReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.damage(amount, player) = action else {
            fatalError("unexpected")
        }
        var playerObj = state.content.get(player)
        playerObj.health -= amount

        var state = state
        state.content[player] = playerObj
        return state
    }
}
