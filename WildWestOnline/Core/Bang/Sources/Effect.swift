//  Effect.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 28/07/2024.
//
// swiftlint:disable type_contents_order discouraged_optional_collection nesting identifier_name

/// An `effect` is a tag which performs an `action` each time an `event` occurs.
public struct Effect: Equatable, Codable {
    public let when: PlayReq
    public let action: ActionType
    public var selectors: [Selector]?

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

        // events on another player
        case otherEliminated
        case otherDamaged
        case otherDamagedByYourCard(String)
        case otherMissedYourShoot(String)
        case otherPlayedCard(String)
    }

    /// An action is some kind of change triggered by user or by the system, that causes any update to the game state
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
        case reveal

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

        /// set {actor}'s {attribute} to {value}
        case setAttribute

        /// increment {actor}'s {attribute} to {value}
        case incrementAttribute
    }

    /// Arguments required for dispatching a specific action
    public enum ActionArgument: String, Codable {
        case healAmount
        case damageAmount
        case repeatAmount
        case revealAmount
        case shootRequiredMisses
        case limitPerTurn
    }

    /// Selectors are used to specify which objects an aura or effect should affect.
    /// Choice is performed by {actor}
    public enum Selector: Equatable, Codable {
        /// determine targetted player
        case target(Target)
        case chooseTarget([TargetCondition]? = nil)

        /// determine affected card
        case card(Card)
        case chooseCard(CardCondition? = nil)

        /// determine affected attribute
        case attribute([PlayerAttribute: Int])

        /// determine other arguments
        case arg(ActionArgument, value: Number)

        /// multiply effect x times
        case `repeat`(Number)

        /// must match given condition
        case `if`(StateCondition)

        /// must `discard` hand card
        case chooseCostHandCard(CardCondition? = nil, count: Int = 1)

        /// can `discard` hand card to counter the effect
        case chooseEventuallyCounterHandCard(CardCondition? = nil, count: Int = 1)

        /// can `discard` hand card to reverse effect
        case chooseEventuallyReverseHandCard(CardCondition)

        /// can choose to loose one life point or skip the effect
        case chooseEventuallyCostLifePoint

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
            case revealed
            case discarded
        }

        public enum Number: Equatable, Codable {
            case activePlayers
            case excessHand
            case damage // damage compared to maxHealth
            case lastDamage // amount from last damage event
            case playerAttr(PlayerAttribute)
            case add(Int, attr: PlayerAttribute)
            case arg(ActionArgument)
            case value(Int)
        }

        public indirect enum StateCondition: Equatable, Codable {
            case playersAtLeast(Int)
            case playedLessThan(Number)
            case draw(String)
            case actorTurn
            case discardedCardsNotAce
            case hasNoBlueCardsInPlay
            case targetHealthIs1
            case not(Self)
        }
    }
}

public enum PlayerAttribute: String, Codable {
    case maxHealth
    case drawCards
    case weapon
    case magnifying
    case remoteness
    case handLimit
    case silentCardsDiamonds
    case silentCardsInPlayDuringTurn
}