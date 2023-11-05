import Foundation

/// Cards that are used in a game.
/// Cards can have a cost, can have multiple properties, define additional rules,
/// have actions that can be played and have side effects that happen when they are being played.
public struct Card: Codable, Equatable {
    
    /// Unique Name
    public let name: String

    /// Card attributes
    public let attributes: Attributes

    /// Actions that can be performed with the card
    public let rules: [CardRule]
}

public struct CardRule: Codable, Equatable {

    /// Conditions to trigger the card effect
    let playReqs: [PlayReq]

    /// Card effect
    let effect: CardEffect
}
