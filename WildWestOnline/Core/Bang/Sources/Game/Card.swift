//
//  Card.swift
//  Bang
//
//  Created by Hugues Telolahy on 28/10/2024.
//

public struct Card: Equatable, Codable {
    public let name: String
    public let desc: String
    public let canPlay: [PlayReq]
    public let onPlay: [ActiveAbility]

    public init(
        name: String,
        desc: String = "",
        canPlay: [PlayReq] = [],
        onPlay: [ActiveAbility] = []
    ) {
        self.name = name
        self.desc = desc
        self.canPlay = canPlay
        self.onPlay = onPlay
    }
}

/// Occurred action when card is played
public struct ActiveAbility: Equatable, Codable {
    public let action: GameAction.Kind
    public let selectors: [ActionSelector]

    public init(
        action: GameAction.Kind,
        selectors: [ActionSelector] = []
    ) {
        self.action = action
        self.selectors = selectors
    }
}

/// Selectors are used to specify which objects an aura or effect should affect.
/// Choice is performed by {actor}
public enum ActionSelector: Equatable, Codable {
    /// apply x times
    case `repeat`(Number)
    case setAmount(Int)

    public enum Number: Equatable, Codable {
        case value(Int)
    }
}

public enum PlayReq: Equatable, Codable {
    case playersAtLeast(Int)
}
