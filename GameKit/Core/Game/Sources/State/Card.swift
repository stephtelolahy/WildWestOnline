import Foundation

/// Cards that are used in a game.
/// Cards can have multiple attributes,
/// have actions that can be played and have side effects that happen when they are being played.
public struct Card: Codable, Equatable {
    /// Unique Name
    public let name: String

    /// Attributes
    public let attributes: [String: Int]

    /// Abilities
    public let abilities: Set<String>

    /// Ability to play card X as Y
    public let abilityToPlayCardAs: [CardAlias]

    /// Effect priority
    public let priority: Int

    /// Actions that can be performed with the card
    public let rules: [CardRule]
}

public struct CardRule: Codable, Equatable {
    /// Card effect
    let effect: CardEffect

    /// Conditions to trigger the card effect
    let playReqs: [PlayReq]
}

public struct CardAlias: Codable, Equatable {
    /// Regex of played card
    let playedRegex: String

    /// Name of card having the play effect 
    let effectCard: String

    /// Conditions to trigger the card alias
    let playReqs: [PlayReq]

    public init(playedRegex: String, as effectCard: String, playReqs: [PlayReq]) {
        self.playedRegex = playedRegex
        self.effectCard = effectCard
        self.playReqs = playReqs
    }
}
