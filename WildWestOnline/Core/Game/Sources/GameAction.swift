//
//  GameAction.swift
//
//  Created by Hugues Telolahy on 27/10/2024.
//
import Redux

public struct GameAction: Action, Equatable, Codable {
    public var name: Name
    public var payload: Payload
    public var selectors: [Card.Selector]

    public enum Name: String, Codable, Sendable {
        case preparePlay
        case play
        case equip
        case handicap
        case draw
        case discover
        case drawDeck
        case drawDiscard
        case drawDiscovered
        @available(*, deprecated, message: "use .stealHand or .stealInPlay instead")
        case steal
        case stealHand
        case stealInPlay
        @available(*, deprecated, message: "use .discardHand or .discardInPlay instead")
        case discard
        case discardHand
        case discardInPlay
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
        case choose
        case increaseMagnifying
        case increaseRemoteness
        case setWeapon
        case setMaxHealth
        case setHandLimit
        case setPlayLimitPerTurn
        case setDrawCards
        case queue
    }

    public struct Payload: Equatable, Codable, Sendable {
        @UncheckedEquatable public var actor: String
        @UncheckedEquatable public var source: String

        // TODO: Payload values must be optional except `actor`and `source`
        public var target: String
        public var card: String?
        public var amount: Int?
        public var selection: String?
        public var children: [GameAction]?
        public var cards: [String]?
        public var amountPerCard: [String: Int]?

        public init(
            actor: String = "",
            source: String = "",
            target: String = "",
            card: String? = nil,
            amount: Int? = nil,
            selection: String? = nil,
            children: [GameAction]? = nil,
            cards: [String]? = nil,
            amountPerCard: [String: Int]? = nil
        ) {
            self.actor = actor
            self.source = source
            self.target = target
            self.card = card
            self.amount = amount
            self.selection = selection
            self.children = children
            self.cards = cards
            self.amountPerCard = amountPerCard
        }
    }

    public init(
        name: Name,
        payload: Payload = .init(),
        selectors: [Card.Selector] = []
    ) {
        self.name = name
        self.selectors = selectors
        self.payload = payload
    }
}

public extension GameAction {
    var isRenderable: Bool {
        guard selectors.isEmpty else {
            return false
        }

        switch name {
        case .queue, .preparePlay:
            return false

        default:
            return true
        }
    }
}
