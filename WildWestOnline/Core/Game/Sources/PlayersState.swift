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

        /// Maximum health
        public let maxHealth: Int

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
        case let GameAction.heal(amount, id):
            try state.heal(amount: amount, id: id)

        case let GameAction.damage(amount, id):
            state.damage(amount: amount, id: id)

        default:
            state
        }
    }
}

private extension PlayersState {
    func heal(amount: Int, id: String) throws -> Self {
        var playerObj = content.get(id)

        guard playerObj.health < playerObj.maxHealth else {
            throw GameError.playerAlreadyMaxHealth(id)
        }

        playerObj.health = min(playerObj.health + amount, playerObj.maxHealth)

        var state = self
        state.content[id] = playerObj
        return state
    }

    func damage(amount: Int, id: String) -> Self {
        var playerObj = content.get(id)
        playerObj.health -= amount

        var state = self
        state.content[id] = playerObj
        return state
    }
}
