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

    // MARK: - Deprecated

    /// Attributes
    @available(*, deprecated, renamed: "setPlayerAttribute")
    public let attributes: [String: Int]

    /// Abilities: included actions from another card
    @available(*, deprecated, message: "remove")
    public let abilities: Set<String>

    /// Ability to play card X as Y
    @available(*, deprecated, message: "remove")
    public let abilityToPlayCardAs: [CardAlias]

    /// Effect priority
    @available(*, deprecated, message: "remove")
    public let priority: Int

    /// Actions that can be performed with the card
    @available(*, deprecated, message: "remove")
    public let rules: [CardRule]

    // MARK: - Constructor

    public init(
        name: String,
        desc: String,
        setPlayerAttribute: [PlayerAttribute: Int] = [:],
        increasePlayerAttribute: [PlayerAttribute: Int] = [:],
        setActionAttribute: [String: [ActionAttribute: Int]] = [:],
        canPlay: Effect.PlayReq? = nil,
        effects: [Effect] = [],
        attributes: [String: Int] = [:],
        abilities: Set<String> = [],
        abilityToPlayCardAs: [CardAlias] = [],
        priority: Int = 0,
        rules: [CardRule] = []
    ) {
        self.name = name
        self.desc = desc
        self.setPlayerAttribute = setPlayerAttribute
        self.setActionAttribute = setActionAttribute
        self.increasePlayerAttribute = increasePlayerAttribute
        self.canPlay = canPlay
        self.effects = effects
        self.attributes = attributes
        self.abilities = Set(abilities)
        self.abilityToPlayCardAs = abilityToPlayCardAs
        self.priority = priority
        self.rules = rules
    }
}
