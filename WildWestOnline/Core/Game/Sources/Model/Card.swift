//
//  Card.swift
//
//  Created by Hugues Telolahy on 28/10/2024.
//
// swiftlint:disable nesting

import Redux

/// We are working on a Card Definition Language that will allow people to create new cards,
/// not currently in the game and see how they play.
/// A `card` is just a collection of effects and attributes
/// ℹ️ Inspired by https://github.com/danielyule/hearthbreaker/wiki/Tag-Format
/// ℹ️ All effects of  the same source share the resolved arguments
///
public struct Card: Equatable, Codable, Sendable {
    public let name: String
    public let desc: String
    public let canPlay: [StateReq]
    public let onPreparePlay: [Effect]
    public let onPlay: [Effect]
    public let canTrigger: [EventReq]
    public let onTrigger: [Effect]
    public let onActive: [Effect]
    public let onDeactive: [Effect]
    public let counterShot: Bool

    public init(
        name: String,
        desc: String = "",
        canPlay: [StateReq] = [],
        onPreparePlay: [Effect] = [],
        onPlay: [Effect] = [],
        canTrigger: [EventReq] = [],
        onTrigger: [Effect] = [],
        onActive: [Effect] = [],
        onDeactive: [Effect] = [],
        counterShot: Bool = false
    ) {
        self.name = name
        self.desc = desc
        self.canPlay = canPlay
        self.onPreparePlay = onPreparePlay
        self.onPlay = onPlay
        self.canTrigger = canTrigger
        self.onTrigger = onTrigger
        self.onActive = onActive
        self.onDeactive = onDeactive
        self.counterShot = counterShot
    }

    public struct Effect: ActionProtocol, Equatable, Codable {
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
            public var children: [Card.Effect]?
            public var cards: [String]?
            public var amountPerCard: [String: Int]?

            public init(
                player: String = "",
                played: String = "",
                target: String? = nil,
                card: String? = nil,
                amount: Int? = nil,
                selection: String? = nil,
                children: [Card.Effect]? = nil,
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
            withPlayer player: String? = nil,
            played: String? = nil,
            target: String? = nil,
            card: String? = nil,
            amount: Int? = nil,
            selectors: [Card.Selector]? = nil
        ) -> Self {
            .init(
                name: name,
                payload: .init(
                    player: player ?? payload.player,
                    played: played ?? payload.played,
                    target: target ?? payload.target,
                    card: card ?? payload.card,
                    amount: amount ?? payload.amount,
                    selection: payload.selection,
                    children: payload.children,
                    cards: payload.cards,
                    amountPerCard: payload.amountPerCard
                ),
                selectors: selectors ?? self.selectors
            )
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            NonStandardLogic.areActionsEqual(lhs, rhs)
        }
    }

    /// Required state conditions to play a card
    public enum StateReq: Equatable, Codable, Sendable {
        case playersAtLeast(Int)
        case playLimitPerTurn([String: Int])
        case healthZero
        case gameOver
        case currentTurn
        case drawMatching(_ regex: String)
        case drawNotMatching(_ regex: String)
    }

    /// Required event conditions to trigger a card
    public struct EventReq: Equatable, Codable, Sendable {
        public let actionName: Card.Effect.Name
        public let stateReqs: [StateReq]

        public init(
            actionName: Effect.Name,
            stateReqs: [StateReq] = []
        ) {
            self.actionName = actionName
            self.stateReqs = stateReqs
        }
    }

    /// Selectors are used to specify which objects an effect should affect.
    /// Choice is performed by {actor}
    public enum Selector: Equatable, Codable, Sendable {
        case `repeat`(Number)
        case setAmountPerCard([String: Int])
        case setTarget(TargetGroup)
        case setCard(CardGroup)
        case chooseOne(ChooseOneElement, resolved: ChooseOneResolved? = nil, selection: String? = nil)
        case verify(StateReq)

        public enum Number: Equatable, Codable, Sendable {
            case value(Int)
            case activePlayers
            case excessHand
            case drawCards
        }

        public enum TargetGroup: String, Codable, Sendable {
            /// All active players
            case active
            /// All damaged players
            case damaged
            /// All other players
            case others
            /// Next player after actor
            case next
        }

        public enum CardGroup: String, Codable, Sendable {
            case allHand
            case allInPlay
            case played
            case equipedWeapon
        }

        public enum ChooseOneElement: Equatable, Codable, Sendable {
            /// Must choose a target
            case target([TargetCondition] = [])
            /// Must choose a target's card
            case card([CardCondition] = [])
            /// Must choose a discovered card
            case discovered
            /// Can `discard` hand card to counter the effect
            case eventuallyCounterCard([CardCondition] = [])
            /// Can `discard` hand card to reverse the effect's target
            case eventuallyReverseCard([CardCondition] = [])
        }

        public struct ChooseOneResolved: Equatable, Codable, Sendable {
            public let chooser: String
            public let options: [Option]

            public init(chooser: String, options: [Option]) {
                self.chooser = chooser
                self.options = options
            }

            public struct Option: Equatable, Codable, Sendable {
                public let value: String
                public let label: String

                public init(value: String, label: String) {
                    self.value = value
                    self.label = label
                }
            }
        }

        public enum TargetCondition: Equatable, Codable, Sendable {
            case havingCard
            case atDistance(Int)
            case reachable
        }

        public enum CardCondition: Equatable, Codable, Sendable {
            case counterShot
            case named(String)
            case fromHand
        }
    }

    /// Error on playing card
    public enum Failure: Error, Equatable, Codable {
        case insufficientDeck
        case insufficientDiscard
        case playerAlreadyMaxHealth(String)
        case noReq(Card.StateReq)
        case noTarget(Card.Selector.TargetGroup)
        case noChoosableTarget([Card.Selector.TargetCondition])
        case cardNotPlayable(String)
        case cardAlreadyInPlay(String)
    }
}

/// ChooseOne options
public extension String {
    /// Hidden hand card
    static let hiddenHand = "hiddenHand"

    /// Pass when asked a counter card
    static let pass = "pass"
}
