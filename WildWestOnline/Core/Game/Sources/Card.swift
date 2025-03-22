//
//  Card.swift
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
    public let onPlay: [GameAction]
    public let canTrigger: [EventReq]
    public let onTrigger: [GameAction]
    public let onActive: [GameAction]
    public let onDeactive: [GameAction]
    public let counterShot: Bool

    public init(
        name: String,
        desc: String = "",
        canPlay: [StateReq] = [],
        onPlay: [GameAction] = [],
        canTrigger: [EventReq] = [],
        onTrigger: [GameAction] = [],
        onActive: [GameAction] = [],
        onDeactive: [GameAction] = [],
        counterShot: Bool = false
    ) {
        self.name = name
        self.desc = desc
        self.canPlay = canPlay
        self.onPlay = onPlay
        self.canTrigger = canTrigger
        self.onTrigger = onTrigger
        self.onActive = onActive
        self.onDeactive = onDeactive
        self.counterShot = counterShot
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
        public let actionName: GameAction.Name
        public let stateReqs: [StateReq]

        public init(
            actionName: GameAction.Name,
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
}

/// ChooseOne options
public extension String {
    /// Hidden hand card
    static let hiddenHand = "hiddenHand"

    /// Pass when asked a counter card
    static let pass = "pass"
}
