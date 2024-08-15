//
//  Card.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 13/08/2024.
//

/// We are working on a Card Definition Language that will allow people to create new cards,
/// not currently in the game and see how they play.
/// A `card` is just a collection of attributes and effects
/// ℹ️ Inspired by https://github.com/danielyule/hearthbreaker/wiki/Tag-Format
/// ℹ️ Before dispatching resolved action, verify initial event is still confirmed as state
/// ℹ️ All effects of the same source share the resolved arguments
///
public struct Card: Equatable, Codable {
    public let id: String
    public let desc: String

    /// set owner's {attribute} to {value}
    @available(*, deprecated, renamed: "setAttribute")
    public var attributes: [PlayerAttribute: Int] = [:]

    /// override other {card}'s action {argument}
    public var overrides: [String: [Action.Argument: Int]] = [:]

    /// allow to play a card {key} with another card {value}
    public var playWith: [String: String] = [:]

    /// can choose to play this card when an {event} occurs
    public var canPlay: Effect.PlayerEvent?

    /// actions that are triggered by this card when some {event} occurrs
    public var effects: [Effect] = []
}
