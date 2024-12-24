//
//  Card.swift
//  Bang
//
//  Created by Hugues Telolahy on 28/10/2024.
//
// swiftlint:disable nesting

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
    public let onPlay: [Effect]
    public let shouldTrigger: [EventReq]
    public let onTrigger: [Effect]
    public let onActive: [Effect]
    public let onDeactive: [Effect]
    public let counterShot: Bool

    public init(
        name: String,
        desc: String = "",
        canPlay: [StateReq] = [],
        onPlay: [Effect] = [],
        shouldTrigger: [EventReq] = [],
        onTrigger: [Effect] = [],
        onActive: [Effect] = [],
        onDeactive: [Effect] = [],
        counterShot: Bool = false
    ) {
        self.name = name
        self.desc = desc
        self.canPlay = canPlay
        self.onPlay = onPlay
        self.shouldTrigger = shouldTrigger
        self.onTrigger = onTrigger
        self.onActive = onActive
        self.onDeactive = onDeactive
        self.counterShot = counterShot
    }

    /// Occurred action when card is played
    public struct Effect: Equatable, Codable, Sendable {
        public let action: GameAction.Kind
        public let selectors: [Selector]

        public init(
            action: GameAction.Kind,
            selectors: [Selector] = []
        ) {
            self.action = action
            self.selectors = selectors
        }
    }

    /// Required state conditions to play a card
    public enum StateReq: Equatable, Codable, Sendable {
        case playersAtLeast(Int)
        case playLimitPerTurn([String: Int])
        case healthZero
        case gameOver
        case currentTurn
        case draw(_ regex: String)
    }

    /// Required event conditions to trigger a card
    public struct EventReq: Equatable, Codable, Sendable {
        public let actionKind: GameAction.Kind
        public let stateReqs: [StateReq]

        public init(
            actionKind: GameAction.Kind,
            stateReqs: [StateReq] = []
        ) {
            self.actionKind = actionKind
            self.stateReqs = stateReqs
        }
    }

    /// Selectors are used to specify which objects an effect should affect.
    /// Choice is performed by {actor}
    public enum Selector: Equatable, Codable, Sendable {
        case `repeat`(Number)
        case setAmount(Int)
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
            /// Next turn player
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

            public struct Option: Equatable, Codable, Sendable {
                public let value: String
                public let label: String
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
}

/// ChooseOne options
public extension String {
    /// Hidden hand card
    static let hiddenHand = "hiddenHand"

    /// Pass when asked a counter card
    static let pass = "pass"
}
