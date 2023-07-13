import Foundation

/// Cards that are used in a game.
/// Cards can have a cost, can have multiple properties, define additional rules,
/// have actions that can be played and have side effects that happen when they are being played.
public struct Card: Codable, Equatable {
    
    /// Unique Name
    public let name: String

    /// The manner a card is played
    public let type: CardType

    /// Actions that can be performed with the card
    public let actions: [CardAction]
}

/// Decsribing the manner a card is played
public enum CardType: String, Codable, CodingKeyRepresentable {

    /// The card has effects that are resolved immediately, and then the card is discarded
    case immediate

    /// Equipment card, put in self's play
    case equipment

    /// Handicap card, put in target's play
    case handicap
}
