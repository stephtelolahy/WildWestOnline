//
//  GameAction.swift
//  Bang
//
//  Created by Hugues Telolahy on 27/10/2024.
//
import Redux

public struct GameAction: Action, Equatable, Codable {
    public let kind: Kind
    public var payload: Payload

    public enum Kind: String, Codable {
        case play
        case draw
        case drawDeck
        case drawDiscard
        case drawDiscovered
        case discover
        case discard
        case heal
        case choose
    }

    public struct Payload: Equatable, Codable {
        public var actor: String
        public var card: String?
        public var amount: Int?
        public var selectors: [ActionSelector] = []
        public var selection: String?
    }
}

public extension GameAction {
    /// Move: play a card
    static func play(_ card: String, player: String) -> Self {
        .init(
            kind: .play,
            payload: .init(
                actor: player,
                card: card
            )
        )
    }

    /// Move: choose an option
    static func choose(_ selection: String) -> Self {
        .init(
            kind: .choose,
            payload: .init(
                actor: "",
                selection: selection
            )
        )
    }

    /// Draw top deck card and put to discard
    static var draw: Self {
        .init(
            kind: .draw,
            payload: .init(
                actor: ""
            )
        )
    }

    /// Draw top deck card
    static func drawDeck(player: String) -> Self {
        .init(
            kind: .drawDeck,
            payload: .init(
                actor: player
            )
        )
    }

    /// Draw top discard
    static func drawDiscard(player: String) -> Self {
        .init(
            kind: .drawDiscard,
            payload: .init(actor: player)
        )
    }

    /// Draw discovered deck card
    static func drawDiscovered(_ card: String, player: String) -> Self {
        .init(
            kind: .drawDiscovered,
            payload: .init(
                actor: player,
                card: card
            )
        )
    }

    /// Discover top deck cards
    static var discover: Self {
        .init(
            kind: .discover,
            payload: .init(
                actor: ""
            )
        )
    }

    /// Restore player's health, limited to maxHealth
    static func heal(_ amount: Int, player: String) -> Self {
        .init(
            kind: .heal,
            payload: .init(
                actor: player,
                amount: amount
            )
        )
    }

    /// Discard a player's hand or inPlay card
    static func discard(_ card: String, player: String) -> Self {
        .init(
            kind: .discard,
            payload: .init(
                actor: player,
                card: card
            )
        )
    }
}
