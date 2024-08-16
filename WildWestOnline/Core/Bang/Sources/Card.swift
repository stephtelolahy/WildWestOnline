//
//  Card.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 13/08/2024.
//

/// We are working on a Card Definition Language that will allow people to create new cards,
/// not currently in the game and see how they play.
/// A `card` is just a collection of effects and attributes
/// ℹ️ Inspired by https://github.com/danielyule/hearthbreaker/wiki/Tag-Format
/// ℹ️ Before dispatching resolved action, verify initial event is still confirmed as state
/// ℹ️ All effects of the same source share the resolved arguments
///
public struct Card: Equatable, Codable {
    /// Unique identifier
    public let id: String

    /// Description
    public let desc: String

    /// Actions that are triggered by this card an {event} occurrs
    public var effects: [Effect] = []

    /// Allow to play this card only when an {event} occurs
    /// By default cards are playable during player's turn
    public var canPlay: Effect.PlayReq?

    /// Ability to override another {card}'s action {argument}
    public var abilityToUpdateCard: [String: [ActionArgument: Int]] = [:]

    /// Ability to play a card {key} with another card {value}
    public var abilityToPlayCardWith: [String: String] = [:]
}
