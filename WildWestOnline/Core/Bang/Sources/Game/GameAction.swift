//
//  GameAction.swift
//  Bang
//
//  Created by Hugues Telolahy on 27/10/2024.
//

public struct GameAction: Action, Equatable, Codable, Sendable {
    public let kind: Kind
    public var payload: Payload

    public enum Kind: String, Codable, Sendable {
        case play
        case draw
        case drawDeck
        case drawDiscard
        case drawDiscovered
        case discover
        case discard
        case heal
        case damage
        case steal
        case shoot
        case endTurn
        case startTurn
        case eliminate
        case endGame
        case activate
        case setWeapon
        case choose
        case queue
        case setMaxHealth
        case increaseMagnifying
        case increaseRemoteness
        case setHandLimit
        case setPlayLimitPerTurn
    }

    public struct Payload: Equatable, Codable, Sendable {
        @UncheckedEquatable var actor: String
        @UncheckedEquatable var source: String
        public var target: String
        public var card: String?
        public var amount: Int?
        public var selection: String?
        public var selectors: [Card.Selector]
        public var children: [GameAction]
        public var cards: [String]

        public init(
            actor: String = "",
            source: String = "",
            target: String = "",
            card: String? = nil,
            amount: Int? = nil,
            selection: String? = nil,
            selectors: [Card.Selector] = [],
            children: [GameAction] = [],
            cards: [String] = []
        ) {
            self.actor = actor
            self.source = source
            self.target = target
            self.card = card
            self.amount = amount
            self.selection = selection
            self.selectors = selectors
            self.children = children
            self.cards = cards
        }
    }

    public init(kind: Kind, payload: Payload) {
        self.kind = kind
        self.payload = payload
    }
}

public extension GameAction {
    /// Move: play a card
    static func play(_ card: String, player: String) -> Self {
        .init(
            kind: .play,
            payload: .init(
                target: player,
                card: card
            )
        )
    }

    /// Move: choose an option
    static func choose(_ selection: String, player: String) -> Self {
        .init(
            kind: .choose,
            payload: .init(
                target: player,
                selection: selection
            )
        )
    }

    /// Draw top deck card and put to discard
    static var draw: Self {
        .init(
            kind: .draw,
            payload: .init()
        )
    }

    /// Draw top deck card
    static func drawDeck(player: String) -> Self {
        .init(
            kind: .drawDeck,
            payload: .init(
                target: player
            )
        )
    }

    /// Draw top discard
    static func drawDiscard(player: String) -> Self {
        .init(
            kind: .drawDiscard,
            payload: .init(target: player)
        )
    }

    /// Draw discovered deck card
    static func drawDiscovered(_ card: String, player: String) -> Self {
        .init(
            kind: .drawDiscovered,
            payload: .init(
                target: player,
                card: card
            )
        )
    }

    /// Discover top deck cards
    static func discover(player: String) -> Self {
        .init(
            kind: .discover,
            payload: .init(target: player)
        )
    }

    /// Restore player's health, limited to maxHealth
    static func heal(_ amount: Int, player: String) -> Self {
        .init(
            kind: .heal,
            payload: .init(
                target: player,
                amount: amount
            )
        )
    }

    /// Deals damage to a player, attempting to reduce its Health by the stated amount
    static func damage(_ amount: Int, player: String) -> Self {
        .init(
            kind: .damage,
            payload: .init(
                target: player,
                amount: amount
            )
        )
    }

    /// Discard a player's hand or inPlay card
    static func discard(_ card: String, player: String) -> Self {
        .init(
            kind: .discard,
            payload: .init(
                target: player,
                card: card
            )
        )
    }

    /// Draw card from other player's hand or inPlay
    static func steal(_ card: String, target: String, player: String) -> Self {
        .init(
            kind: .steal,
            payload: .init(
                actor: player,
                target: target,
                card: card
            )
        )
    }

    /// Shoot a player
    static func shoot(_ target: String, player: String) -> Self {
        .init(
            kind: .shoot,
            payload: .init(
                actor: player,
                target: target
            )
        )
    }

    /// Start turn
    static func startTurn(player: String) -> Self {
        .init(
            kind: .startTurn,
            payload: .init(
                target: player
            )
        )
    }

    /// End turn
    static func endTurn(player: String) -> Self {
        .init(
            kind: .endTurn,
            payload: .init(
                target: player
            )
        )
    }

    /// Eliminate
    static func eliminate(player: String) -> Self {
        .init(
            kind: .eliminate,
            payload: .init(
                target: player
            )
        )
    }

    /// End game
    static func endGame(player: String) -> Self {
        .init(
            kind: .endGame,
            payload: .init(
                target: player
            )
        )
    }

    /// Expose active cards
    static func activate(_ cards: [String], player: String) -> Self {
        .init(
            kind: .activate,
            payload: .init(target: player, cards: cards)
        )
    }

    /// End game
    static func setWeapon(_ weapon: Int, player: String) -> Self {
        .init(
            kind: .setWeapon,
            payload: .init(target: player, amount: weapon)
        )
    }
}

extension GameAction: CustomStringConvertible {
    public var description: String {
        var parts: [String] = []
        if payload.selectors.isNotEmpty {
            parts.append("..")
        }
        parts.append(kind.emoji)
        parts.append(payload.target)

        if let card = payload.card {
            parts.append(card)
        }

        if let selection = payload.selection {
            parts.append(selection)
        }

        parts.append(contentsOf: payload.cards)

        if let amount = payload.amount {
            parts.append("x \(amount)")
        }

        if payload.source.isNotEmpty {
            parts.append("<< \(payload.source):\(payload.actor)")
        }

        return parts.joined(separator: " ")
    }
}

private extension GameAction.Kind {
    var emoji: String {
        Self.dict[self] ?? "⚠️\(rawValue)"
    }

    static let dict: [GameAction.Kind: String] = [
        .play: "🟡",
        .heal: "❤️",
        .damage: "🥵",
        .drawDeck: "💰",
        .drawDiscard: "💰",
        .drawDiscovered: "💰",
        .steal: "‼️",
        .discard: "❌",
        .draw: "🎲",
        .discover: "🎁",
        .shoot: "🔫",
        .startTurn: "🔥",
        .endTurn: "💤",
        .eliminate: "☠️",
        .endGame: "🎉",
        .choose: "🎯",
        .activate: "🟢",
        .queue: "➕"
    ]
}
