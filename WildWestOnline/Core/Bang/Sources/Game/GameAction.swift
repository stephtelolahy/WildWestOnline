//
//  GameAction.swift
//  Bang
//
//  Created by Hugues Telolahy on 27/10/2024.
//
// swiftlint:disable file_length

public struct GameAction: Action, Equatable, Codable {
    public var kind: Kind
    public var payload: Payload

    public enum Kind: String, Codable, Sendable {
        case play
        case draw
        case drawDeck
        case drawDiscard
        case drawDiscovered
        case discover
        case discardHand
        case discardInPlay
        case stealHand
        case stealInPlay
        case passInPlay
        case heal
        case damage
        case shoot
        case counterShot
        case endTurn
        case startTurn
        case eliminate
        case endGame
        case activate
        case setWeapon
        case choose
        case discardPlayed
        case equip
        case handicap
        case setMaxHealth
        case increaseMagnifying
        case increaseRemoteness
        case setHandLimit
        case setPlayLimitPerTurn
        case setDrawCards

        @available(*, deprecated, message: "use .discardHand or .discardInPlay instead")
        case discard
        @available(*, deprecated, message: "use .stealHand or .stealInPlay instead")
        case steal
        case queue
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
        public var amountPerCard: [String: Int]

        public init(
            actor: String = "",
            source: String = "",
            target: String = "",
            card: String? = nil,
            amount: Int? = nil,
            selection: String? = nil,
            selectors: [Card.Selector] = [],
            children: [GameAction] = [],
            cards: [String] = [],
            amountPerCard: [String: Int] = [:]
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
            self.amountPerCard = amountPerCard
        }
    }

    public init(kind: Kind, payload: Payload) {
        self.kind = kind
        self.payload = payload
    }
}

public extension GameAction {
    static func play(_ card: String, player: String) -> Self {
        .init(
            kind: .play,
            payload: .init(
                target: player,
                card: card
            )
        )
    }

    static func choose(_ selection: String, player: String) -> Self {
        .init(
            kind: .choose,
            payload: .init(
                target: player,
                selection: selection
            )
        )
    }

    static func draw(player: String) -> Self {
        .init(
            kind: .draw,
            payload: .init(
                target: player
            )
        )
    }

    static func drawDeck(player: String) -> Self {
        .init(
            kind: .drawDeck,
            payload: .init(
                target: player
            )
        )
    }

    static func drawDiscard(player: String) -> Self {
        .init(
            kind: .drawDiscard,
            payload: .init(target: player)
        )
    }

    static func drawDiscovered(_ card: String, player: String) -> Self {
        .init(
            kind: .drawDiscovered,
            payload: .init(
                target: player,
                card: card
            )
        )
    }

    static func discover(player: String) -> Self {
        .init(
            kind: .discover,
            payload: .init(target: player)
        )
    }

    static func heal(_ amount: Int, player: String) -> Self {
        .init(
            kind: .heal,
            payload: .init(
                target: player,
                amount: amount
            )
        )
    }

    static func damage(_ amount: Int, player: String) -> Self {
        .init(
            kind: .damage,
            payload: .init(
                target: player,
                amount: amount
            )
        )
    }

    static func discardHand(_ card: String, player: String) -> Self {
        .init(
            kind: .discardHand,
            payload: .init(
                target: player,
                card: card
            )
        )
    }

    static func discardInPlay(_ card: String, player: String) -> Self {
        .init(
            kind: .discardInPlay,
            payload: .init(
                target: player,
                card: card
            )
        )
    }

    static func stealHand(_ card: String, target: String, player: String) -> Self {
        .init(
            kind: .stealHand,
            payload: .init(
                actor: player,
                target: target,
                card: card
            )
        )
    }

    static func stealInPlay(_ card: String, target: String, player: String) -> Self {
        .init(
            kind: .stealInPlay,
            payload: .init(
                actor: player,
                target: target,
                card: card
            )
        )
    }

    static func passInPlay(_ card: String, target: String, player: String) -> Self {
        .init(
            kind: .passInPlay,
            payload: .init(
                actor: player,
                target: target,
                card: card
            )
        )
    }

    static func shoot(_ target: String, player: String) -> Self {
        .init(
            kind: .shoot,
            payload: .init(
                actor: player,
                target: target
            )
        )
    }

    static func counterShoot(player: String) -> Self {
        .init(
            kind: .counterShot,
            payload: .init(
                target: player
            )
        )
    }

    static func startTurn(player: String) -> Self {
        .init(
            kind: .startTurn,
            payload: .init(
                target: player
            )
        )
    }

    static func endTurn(player: String) -> Self {
        .init(
            kind: .endTurn,
            payload: .init(
                target: player
            )
        )
    }

    static func eliminate(player: String) -> Self {
        .init(
            kind: .eliminate,
            payload: .init(
                target: player
            )
        )
    }

    static func endGame(player: String) -> Self {
        .init(
            kind: .endGame,
            payload: .init(
                target: player
            )
        )
    }

    static func activate(_ cards: [String], player: String) -> Self {
        .init(
            kind: .activate,
            payload: .init(target: player, cards: cards)
        )
    }

    static func discardPlayed(_ card: String, player: String) -> Self {
        .init(
            kind: .discardPlayed,
            payload: .init(
                target: player,
                card: card
            )
        )
    }

    static func equip(_ card: String, player: String) -> Self {
        .init(
            kind: .equip,
            payload: .init(
                target: player,
                card: card
            )
        )
    }

    static func handicap(_ card: String, target: String, player: String) -> Self {
        .init(
            kind: .handicap,
            payload: .init(
                actor: player,
                target: target,
                card: card
            )
        )
    }

    static func setWeapon(_ weapon: Int, player: String) -> Self {
        .init(
            kind: .setWeapon,
            payload: .init(target: player, amount: weapon)
        )
    }

    static func setPlayLimitPerTurn(_ limit: [String: Int], player: String) -> Self {
        .init(
            kind: .setPlayLimitPerTurn,
            payload: .init(
                target: player,
                amountPerCard: limit
            )
        )
    }

    static func increaseMagnifying(_ amount: Int, player: String) -> Self {
        .init(
            kind: .increaseMagnifying,
            payload: .init(
                target: player,
                amount: amount
            )
        )
    }

    static func increaseRemoteness(_ amount: Int, player: String) -> Self {
        .init(
            kind: .increaseRemoteness,
            payload: .init(
                target: player,
                amount: amount
            )
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
        .play: "⚪️",
        .heal: "❤️",
        .damage: "🥵",
        .drawDeck: "💰",
        .drawDiscard: "💰",
        .drawDiscovered: "💰",
        .stealHand: "‼️",
        .stealInPlay: "‼️",
        .discardHand: "❌",
        .discardInPlay: "❌",
        .passInPlay: "💣",
        .draw: "🎲",
        .discover: "🎁",
        .shoot: "🔫",
        .startTurn: "🔥",
        .endTurn: "💤",
        .eliminate: "☠️",
        .endGame: "🎉",
        .choose: "🎯",
        .activate: "🟢",
        .discardPlayed: "🟠",
        .equip: "🔵",
        .queue: "➕",
        .setWeapon: "😎",
        .increaseMagnifying: "😎",
        .increaseRemoteness: "😎"
    ]
}
