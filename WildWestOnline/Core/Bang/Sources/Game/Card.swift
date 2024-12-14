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
/// ℹ️ Before dispatching resolved action, verify initial event is still confirmed as state
/// ℹ️ All effects of the same source share the resolved arguments
///
public struct Card: Equatable, Codable, Sendable {
    public let name: String
    public let desc: String
    public let canPlay: [StateReq]
    public let onPlay: [Effect]
    public let canTrigger: [EventReq]
    public let onTrigger: [Effect]
    public let passive: [Effect]
    public let counterShot: Bool

    public init(
        name: String,
        desc: String = "",
        canPlay: [StateReq] = [],
        onPlay: [Effect] = [],
        canTrigger: [EventReq] = [],
        onTrigger: [Effect] = [],
        passive: [Effect] = [],
        counterShot: Bool = false
    ) {
        self.name = name
        self.desc = desc
        self.canPlay = canPlay
        self.onPlay = onPlay
        self.counterShot = counterShot
        self.canTrigger = canTrigger
        self.onTrigger = onTrigger
        self.passive = passive
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
        case playedThisTurnAtMost([String: Int])
        case healthZero
        case gameOver
        case currentTurn
    }

    /// Required event conditions to trigger a card
    public struct EventReq: Equatable, Codable, Sendable {
        public let actionKind: GameAction.Kind
        public let stateConditions: [StateReq]

        public init(
            actionKind: GameAction.Kind,
            stateConditions: [StateReq] = []
        ) {
            self.actionKind = actionKind
            self.stateConditions = stateConditions
        }
    }

    /// Selectors are used to specify which objects an aura or effect should affect.
    /// Choice is performed by {actor}
    public enum Selector: Equatable, Codable, Sendable {
        case `repeat`(Number)
        case setAmount(Int)
        case setTarget(TargetGroup)
        case setCard(CardGroup)
        case chooseOne(ChooseOneElement, resolved: ChooseOneResolved? = nil, selection: String? = nil)

        public enum Number: Equatable, Codable, Sendable {
            case value(Int)
            case activePlayers
            case excessHand
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
            case all
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

/*

     /// Selectors are used to specify which objects an aura or effect should affect.
     /// Choice is performed by {actor}
     public enum Selector: Equatable, Codable {
         /// must `discard` hand card
         case chooseCostHandCard(CardCondition? = nil, count: Int = 1)

         /// can `discard` hand card to counter the effect
         case chooseEventuallyCounterHandCard(CardCondition? = nil, count: Int = 1)

         /// can `discard` hand card to reverse effect
         case chooseEventuallyReverseHandCard(CardCondition)

         /// apply effect x times
         case `repeat`(Number)

         /// must match given condition
         case verify(Card.StateReq)

         public enum Target: String, Codable {
             case actor      // who is playing the card
             case next       // next player after actor
             case offender   // actor of previous attack
             case eliminated // just eliminated player
             case targeted   // target of previous attack
         }

         public enum TargetCondition: Equatable, Codable {
             case atDistance(Int)
             case atDistanceReachable
             case neighbourToTarget
             case havingCard
             case havingHandCard
             case havingInPlayCard
         }

         public enum Card: Equatable, Codable {
             case played
             case all
             case inPlayWithAttr(PlayerAttribute)
         }

         public enum CardCondition: Equatable, Codable {
             case fromHand
             case inPlay
             case isBlue
             case suits(String)
             case named(String)
             case action(ActionType)
             case discovered
             case discarded
         }

         public enum Number: Equatable, Codable {
             case activePlayers
             case excessHand
             case wound
             case damage
             case value(Int)
         }

         public indirect enum Card.StateReq: Equatable, Codable {
             case playersAtLeast(Int)
             case limitPerTurn(Int)
             case draw(String)
             case actorTurn
             case discardedCardsNotAce
             case hasNoBlueCardsInPlay
             case targetHealthIs1
             case not(Self)
         }
     }
 }
 */
