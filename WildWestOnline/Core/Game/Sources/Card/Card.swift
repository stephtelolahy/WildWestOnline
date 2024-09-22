//
//  Card.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 22/07/2024.
//

/// We are working on a Card Definition Language that will allow people to create new cards,
/// not currently in the game and see how they play.
/// A `card` is just a collection of effects and attributes
/// ℹ️ Inspired by https://github.com/danielyule/hearthbreaker/wiki/Tag-Format
///
public struct Card: Codable, Equatable {
    /// Unique Name
    public let name: String

    /// Description
    public let desc: String

    /// Passive ability to set player attributes
    public let setPlayerAttribute: [PlayerAttribute: Int]

    /// Passive ability to increment player attributes
    public let increasePlayerAttribute: [PlayerAttribute: Int]

    /// Passive ability to set some {card}'s action attributes
    public let setActionAttribute: [String: [ActionAttribute: Int]]

    /// Allow to play this card only when an {event} occurs
    /// By default cards are playable during player's turn
    public let canPlay: Effect.PlayReq?

    /// Triggered action when a event occurred
    public let effects: [Effect]

    // MARK: - Constructor

    public init(
        name: String,
        desc: String = "",
        setPlayerAttribute: [PlayerAttribute: Int] = [:],
        increasePlayerAttribute: [PlayerAttribute: Int] = [:],
        setActionAttribute: [String: [ActionAttribute: Int]] = [:],
        canPlay: Effect.PlayReq? = nil,
        effects: [Effect] = []
    ) {
        self.name = name
        self.desc = desc
        self.setPlayerAttribute = setPlayerAttribute
        self.setActionAttribute = setActionAttribute
        self.increasePlayerAttribute = increasePlayerAttribute
        self.canPlay = canPlay
        self.effects = effects
    }
}
