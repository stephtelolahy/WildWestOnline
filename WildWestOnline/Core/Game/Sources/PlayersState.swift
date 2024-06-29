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
        case let GameAction.heal(amount, player):
            try state.heal(amount: amount, player: player)

        case let GameAction.damage(amount, player):
            state.damage(amount: amount, player: player)

        default:
            state
        }
    }
}

private extension PlayersState {
    func heal(amount: Int, player: String) throws -> Self {
        var playerObj = content.get(player)

        guard playerObj.health < playerObj.maxHealth else {
            throw GameError.playerAlreadyMaxHealth(player)
        }

        playerObj.health = min(playerObj.health + amount, playerObj.maxHealth)

        var state = self
        state.content[player] = playerObj
        return state
    }

    func damage(amount: Int, player: String) -> Self {
        var playerObj = content.get(player)
        playerObj.health -= amount

        var state = self
        state.content[player] = playerObj
        return state
    }
}
