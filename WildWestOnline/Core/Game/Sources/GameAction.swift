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
        public let player: String
        public let played: String
        public var target: String?
        public var card: String?
        public var amount: Int?
        public var selection: String?
        public var children: [GameAction]?
        public var cards: [String]?
        public var amountPerCard: [String: Int]?

        public init(
            player: String,
            played: String,
            target: String? = nil,
            card: String? = nil,
            amount: Int? = nil,
            selection: String? = nil,
            children: [GameAction]? = nil,
            cards: [String]? = nil,
            amountPerCard: [String: Int]? = nil
        ) {
            self.player = player
            self.played = played
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
        payload: Payload = .init(player: "", played: ""),
        selectors: [Card.Selector] = []
    ) {
        self.name = name
        self.selectors = selectors
        self.payload = payload
    }

    public func copy(
        withPlayer player: String,
        played: String,
        target: String?
    ) -> Self {
        .init(
            name: name,
            payload: .init(
                player: player,
                played: played,
                target: target,
                card: payload.card,
                amount: payload.amount,
                selection: payload.selection,
                children: payload.children,
                cards: payload.cards,
                amountPerCard: payload.amountPerCard
            ),
            selectors: selectors
        )
    }

    // <Migrate to default Equatable conformance>
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch lhs.name {
        case .queue,
                .preparePlay,
                .play,
                .equip,
                .handicap,
                .choose:
            guard
                lhs.payload.player == rhs.payload.player,
                lhs.payload.played == rhs.payload.played
            else {
                return false
            }

        default:
            break
        }

        return lhs.name == rhs.name
        && lhs.selectors == rhs.selectors
        && lhs.payload.target == rhs.payload.target
        && lhs.payload.card == rhs.payload.card
        && lhs.payload.amount == rhs.payload.amount
        && lhs.payload.selection == rhs.payload.selection
        && lhs.payload.children == rhs.payload.children
        && lhs.payload.cards == rhs.payload.cards
        && lhs.payload.amountPerCard == rhs.payload.amountPerCard
    }
    // </Migrate to default Equatable conformance>
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
