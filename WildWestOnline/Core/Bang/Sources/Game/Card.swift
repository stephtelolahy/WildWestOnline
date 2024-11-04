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
    public let onPlay: [ActiveAbility]

    public init(
        name: String,
        desc: String = "",
        onPlay: [ActiveAbility] = []
    ) {
        self.name = name
        self.desc = desc
        self.onPlay = onPlay
    }
}

/// Occurred action when card is played
public struct ActiveAbility: Equatable, Codable {
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

/// Selectors are used to specify which objects an aura or effect should affect.
/// Choice is performed by {actor}
public enum ActionSelector: Equatable, Codable {
    case `repeat`(Number)
    case setAmount(Number)
    case setTarget(TargetGroup)
    case verify(StateCondition)
    case chooseOne(ChooseOneDetails)

    public enum Number: Equatable, Codable {
        case value(Int)
    }

    public enum TargetGroup: String, Codable {
        case damaged
    }

    public enum StateCondition: Equatable, Codable {
        case playersAtLeast(Int)
    }

    public struct ChooseOneDetails: Equatable, Codable {
        public let element: Element
        public var options: [Option] = []
        public var selection: String?

        public enum Element: Equatable, Codable {
            case target([TargetCondition] = [])
            case card
        }

        public struct Option: Equatable, Codable {
            public let value: String
            public let label: String

            public init(value: String, label: String) {
                self.value = value
                self.label = label
            }
        }
    }

    public enum TargetCondition: Equatable, Codable {
        case havingCard
        case atDistance(Int)
    }
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
         /// set targetted player
         case setTarget(Target)

         /// set affected card
         case setCard(Card)

         /// set action attributes
         case setAttribute(ActionAttribute, value: Number)

         /// choose targeted player
         case chooseTarget([TargetCondition]? = nil)

         /// choose used card
         case chooseCard(CardCondition? = nil)

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
             case all        // all players
             case others     // other players
             case next       // next player after actor
             case offender   // actor of previous attack
             case damaged    // just damaged player
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

 public enum ActionType: String, Codable {
     /// {target} increase health by {amount}
     /// By default target is {actor}
     /// By default heal amount is 1
     case heal

     /// {target} decrease health by {amount}
     /// By default target is {actor}
     /// By default damage amount is 1
     case damage

     /// {actor} draw the top deck card
     /// When a {card} is specified, this allow to draw a specific card
     case drawDeck

     /// {target} discard a {card}
     /// By default target is {actor}
     case discard

     /// {actor} discard silently a {card}
     case discardSilently

     /// {actor} steal a {card} from {target}
     case steal

     /// {actor} put a {card} is self's inPlay
     case equip

     /// {actor} put a {card} on {target}'s inPlay
     case handicap

     /// {actor} shoot at {target} with {damage} and {requiredMisses}
     /// By default damage is 1
     /// By default requiredMisses is 1
     case shoot

     /// {actor} counter a shot applied on himself
     case missed

     /// expose {amount} choosable cards from top deck
     case discover

     /// draw {drawCards} cards from deck. Next effects depend on it
     case draw

     /// {actor} shows his last drawn card
     case showLastDraw

     /// {actor} ends his turn
     case endTurn

     /// {target} starts his turn
     case startTurn

     /// {actor} gets eliminated
     case eliminate

     /// {actor} draws the last discarded card
     /// When a {card} is specified, this allow to draw a specific card
     case drawDiscard

     /// Counter card effect targetting self
     case counter
 }

 public enum ActionAttribute: String, Codable {
     case healAmount
     case damageAmount
     case discoverAmount
     case shootRequiredMisses
     case playableAsBang
     case playableAsMissed
     case labeledAsBang
     case eventuallySilent
     case silent
     case playedByOtherHasNoEffect
     case inPlayOfOtherHasNoEffect
     case ignoreLimitPerTurn
 }

 */
