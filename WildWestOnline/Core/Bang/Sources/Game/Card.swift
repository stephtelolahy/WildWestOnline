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
public struct Card: Equatable, Codable {
    public let name: String
    public let desc: String
    public let canPlay: [PlayReq]
    public let onPlay: [ActiveEffect]
    public let onTrigger: [TiggeredEffect]
    public let counterShot: Bool

    public init(
        name: String,
        desc: String = "",
        canPlay: [PlayReq] = [],
        onPlay: [ActiveEffect] = [],
        onTrigger: [TiggeredEffect] = [],
        counterShot: Bool = false
    ) {
        self.name = name
        self.desc = desc
        self.canPlay = canPlay
        self.onPlay = onPlay
        self.counterShot = counterShot
        self.onTrigger = onTrigger
    }
}

/// Occurred action when card is played
public struct ActiveEffect: Equatable, Codable {
    public let action: GameAction.Kind
    public let selectors: [ActionSelector]

    public init(
        action: GameAction.Kind,
        selectors: [ActionSelector] = []
    ) {
        self.action = action
        self.selectors = selectors
    }
}

/// Occurred action when card is triggered
public struct TiggeredEffect: Equatable, Codable {
    public let action: GameAction.Kind
    public let selectors: [ActionSelector]
    public let when: EventReq

    // swiftlint:disable:next function_default_parameter_at_end
    public init(
        action: GameAction.Kind,
        selectors: [ActionSelector] = [],
        when: EventReq
    ) {
        self.action = action
        self.selectors = selectors
        self.when = when
    }
}

/// Required event conditions to trigger a card
public struct EventReq: Equatable, Codable, Sendable {
    public let kind: GameAction.Kind

    public init(kind: GameAction.Kind) {
        self.kind = kind
    }
}

/// Required state conditions to play a card
public enum PlayReq: Equatable, Codable, Sendable {
    case playersAtLeast(Int)
    case playedThisTurnAtMost([String: Int])
}

/// Selectors are used to specify which objects an aura or effect should affect.
/// Choice is performed by {actor}
public enum ActionSelector: Equatable, Codable, Sendable {
    case `repeat`(Number)
    case setAmount(Int)
    case setTarget(TargetGroup)
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

/// ChooseOne options
public extension String {
    /// Hidden hand card
    static let hiddenHand = "hiddenHand"

    /// Pass when asked a counter card
    static let pass = "pass"
}

/*
 public struct CardV2: Equatable, Codable {
     /// Unique name
     public let name: String

     /// Description
     public let desc: String

     /// Passive ability to set player attributes
     public let setPlayerAttribute: [PlayerAttribute: Int]

     /// Passive ability to increment player attributes
     public let increasePlayerAttribute: [PlayerAttribute: Int]

     /// Passive ability to set some {card}'s action attributes
     public let setActionAttribute: [String: [ActionAttribute: Int]]

     /// Allow to play this card only when an {event} occurs
     /// By default cards are playable during player's turn
     public let canPlay: Effect.PlayReq?

     /// Triggered action when a event occurred
     public let effects: [Effect]

     public init(
         name: String,
         desc: String,
         setPlayerAttribute: [PlayerAttribute: Int] = [:],
         increasePlayerAttribute: [PlayerAttribute: Int] = [:],
         setActionAttribute: [String: [ActionAttribute: Int]] = [:],
         canPlay: Effect.PlayReq? = nil,
         effects: [Effect] = []
     ) {
         self.name = name
         self.desc = desc
         self.setPlayerAttribute = setPlayerAttribute
         self.setActionAttribute = setActionAttribute
         self.increasePlayerAttribute = increasePlayerAttribute
         self.canPlay = canPlay
         self.effects = effects
     }
 }

 /// An `effect` is a tag which performs an `action` each time an `event` occurs.
 public struct Effect: Equatable, Codable {
     public let action: ActionType
     public var selectors: [Selector]?
     public let when: PlayReq

     /// Selectors are used to specify which objects an aura or effect should affect.
     /// Choice is performed by {actor}
     public enum Selector: Equatable, Codable {
         /// set affected card
         case setCard(Card)

         /// set action attributes
         case setAttribute(ActionAttribute, value: Number)

         /// must `discard` hand card
         case chooseCostHandCard(CardCondition? = nil, count: Int = 1)

         /// can `discard` hand card to counter the effect
         case chooseEventuallyCounterHandCard(CardCondition? = nil, count: Int = 1)

         /// can `discard` hand card to reverse effect
         case chooseEventuallyReverseHandCard(CardCondition)

         /// apply effect x times
         case `repeat`(Number)

         /// must match given condition
         case verify(StateCondition)

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

         public indirect enum StateCondition: Equatable, Codable {
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

     /// Triggering events for effects
     public indirect enum PlayReq: Equatable, Codable {
         // events on actor
         case played
         case playedCardOutOfTurn
         case playedCardWithName(String)
         case playedCardWithAttr(PlayerAttribute)
         case shot
         case turnStarted
         case turnEnded
         case damaged
         case damagedByCard(String)
         case damagedLethal
         case eliminated
         case cardStolen
         case cardDiscarded
         case handEmpty
         case targetedWithCardOthertThan(String)

         // events on another player
         case otherEliminated
         case otherDamaged
         case otherDamagedByYourCard(String)
         case otherMissedYourShoot(String)
         case otherPlayedCard(String)
     }

     public init(
         action: ActionType,
         selectors: [Selector]? = nil,
         when: PlayReq = .played
     ) {
         self.action = action
         self.selectors = selectors
         self.when = when
     }
 }

 public enum PlayerAttribute: String, Codable {
     case maxHealth
     case drawCards
     case weapon
     case handLimit
     case magnifying
     case remoteness

     /// player cannot be killed but leave the game immediately after his turn
     case ghost
 }
 */
