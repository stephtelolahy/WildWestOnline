//
//  PlayersState.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 24/06/2024.
//

import Foundation
import Redux

public typealias PlayersState = [String: Player]

public struct Player: Equatable, Codable {
    /// Life points
    public var health: Int

    /// Current attributes
    public var attributes: [String: Int]

    /// Inner abilities
    public let abilities: Set<String>

    /// Figure name. Determining initial attributes
    public let figure: String
}

public extension PlayersState {
    static let reducer: ThrowingReducer<Self> = { state, action in
        switch action {
        case GameAction.heal:
            try healReducer(state, action)

        case GameAction.damage:
            try damageReducer(state, action)

        case GameAction.setAttribute:
            try setAttributeReducer(state, action)

        case GameAction.removeAttribute:
            try removeAttributeReducer(state, action)

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
        var playerObj = state.get(player)
        let maxHealth = playerObj.attributes.get(.maxHealth)

        guard playerObj.health < maxHealth else {
            throw GameError.playerAlreadyMaxHealth(player)
        }

        playerObj.health = Swift.min(playerObj.health + amount, maxHealth)

        var state = state
        state[player] = playerObj
        return state
    }

    static let damageReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.damage(amount, player) = action else {
            fatalError("unexpected")
        }
        var playerObj = state.get(player)
        playerObj.health -= amount

        var state = state
        state[player] = playerObj
        return state
    }

    static let setAttributeReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.setAttribute(key, value, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self[player]]?.setValue(value, forAttribute: key)
        return state
    }

    static let removeAttributeReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.removeAttribute(key, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state[keyPath: \Self[player]]?.setValue(nil, forAttribute: key)
        return state
    }
}

extension Player {
    mutating func setValue(_ value: Int?, forAttribute key: String) {
        attributes[key] = value
    }
}

public extension Player {
    class Builder {
        private var id: String = UUID().uuidString
        private var figure: String = ""
        private var abilities: Set<String> = []
        private var attributes: [String: Int] = [:]
        private var health: Int = 0
        private var hand: [String] = []
        private var inPlay: [String] = []

        public func build() -> Player {
            .init(
                health: health,
                attributes: attributes,
                abilities: abilities,
                figure: figure
            )
        }

        public func buildHand() -> [String] {
            hand
        }

        public func buildInPlay() -> [String] {
            inPlay
        }

        public func withId(_ value: String) -> Self {
            id = value
            return self
        }

        public func withFigure(_ value: String) -> Self {
            figure = value
            return self
        }

        public func withHealth(_ value: Int) -> Self {
            health = value
            return self
        }

        public func withAttributes(_ value: [String: Int]) -> Self {
            attributes = value
            return self
        }

        public func withAbilities(_ value: [String]) -> Self {
            abilities = Set(value)
            return self
        }

        public func withHand(_ value: [String]) -> Self {
            hand = value
            return self
        }

        public func withInPlay(_ value: [String]) -> Self {
            inPlay = value
            return self
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}