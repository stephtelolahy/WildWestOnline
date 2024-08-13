//
//  Card.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 13/08/2024.
//

/// We are working on a Card Definition Language that will allow people to create new cards,
/// not currently in the game and see how they play.
/// A `card` is just a collection of effects using `Tag system`
/// ℹ️ Inspired by https://github.com/danielyule/hearthbreaker/wiki/Tag-Format
/// ℹ️ Before dispatching resolved action, verify initial event is still confirmed as state
/// 
public struct Card: Equatable, Codable {
    public let id: String
    public let desc: String

    /// set owner's {attribute} to {value}
    public var attributes: [PlayerAttribute: Int] = [:]

    /// increase owner's {attribute} by {value}
    public var improvements: [PlayerAttribute: Int] = [:]

    /// override other {card}'s action {argument}
    public var overrides: [String: [Action.Argument: Int]] = [:]

    /// can play a card {key} as with another card {value}
    public var playWith: [String: String] = [:]

    /// actions that are triggered by this card when some {event} occurrs
    public var effects: [Effect] = []
}
