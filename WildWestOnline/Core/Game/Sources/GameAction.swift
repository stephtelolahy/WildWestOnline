//
//  GameAction.swift
//
//  Created by Hugues Telolahy on 27/10/2024.
//
import Redux

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
}

public extension GameAction {
    var isRenderable: Bool {
        kind != .queue && payload.selectors.isEmpty
    }
}
