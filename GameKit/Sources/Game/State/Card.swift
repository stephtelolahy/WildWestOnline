import Foundation

/// Cards that are used in a game.
/// Cards can have multiple attributes,
/// have actions that can be played and have side effects that happen when they are being played.
public struct Card: Codable, Equatable {
    /// Unique Name
    public let name: String

    /// Included attributes or another card features
    public let attributes: [String: Int]

    /// Playable card alias
    public let alias: [CardAlias]

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
    /// Name of card having the play effect
    let card: String

    /// Regex of alias card
    let regex: String

    /// Conditions to trigger the card alias
    let playReqs: [PlayReq]

    public init(card: String, regex: String, playReqs: [PlayReq] = []) {
        self.card = card
        self.regex = regex
        self.playReqs = playReqs
    }
}
