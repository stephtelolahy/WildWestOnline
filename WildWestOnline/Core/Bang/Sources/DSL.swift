// swiftlint:disable:this file_name
//  DSL.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 28/07/2024.
//
// swiftlint:disable type_contents_order discouraged_optional_collection nesting identifier_name

/// An `effect` is a tag which performs an `action` each time an `event` occurs.
public struct Effect: Equatable, Codable {
    public let when: PlayerEvent
    public let action: GameAction
    public let selectors: [Selector]?

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
        case playerAttribute(PlayerAttribute, value: Int)
        case effectAttribute(EffectAttribute, value: Int)

        /// determine other argument
        case arg(ActionArg, value: Number)

        /// multiply effect x times
        case `repeat`(Number)

        /// must match given condition
        case `if`(StateCondition)

        /// must discard hand card
        case chooseCostHandCard(CardCondition? = nil, count: Int = 1)

        /// can discard hand card to counter the effect
        case chooseEventuallyCounterHandCard(CardCondition? = nil, count: Int = 1)

        /// can discard hand card to reverse effect
        case chooseEventuallyReverseHandCard(CardCondition)

        /// can choose a card or skip the effect
        case chooseEventuallyCard(CardCondition)

        /// can choose to loose one life point or skip the effect
        case chooseEventuallyLooseLifePoint

        public enum Target: String, Codable {
            case actor
            case all
            case others
            case next
            case offender
            case eliminated
            case damaged
        }

        public enum TargetCondition: Equatable, Codable {
            case atDistance(Number)
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
            case named(String)
            case action(GameAction)
            case choosable
        }

        public enum ActionArg: String, Codable {
            case healAmount
            case damageAmount
            case shootRequiredMisses
            case revealCount
        }

        public enum Number: Equatable, Codable {
            case activePlayers
            case excessHand
            case damage // damage compared to maxHealth
            case lastDamage // amount from last damage event
            case playerAttr(PlayerAttribute)
            case effectAttr(EffectAttribute)
            case add(Int, attr: PlayerAttribute)
            case value(Int)
        }

        public indirect enum StateCondition: Equatable, Codable {
            case playersAtLeast(Int)
            case playedLessThan(Number)
            case draw(String)
            case actorTurn
            case discardedCardsNotAce
            case hasNoBlueCardsInPlay
            case not(Self)
        }
    }

    public indirect enum PlayerEvent: Equatable, Codable {
        case played
        case shot
        case turnStarted
        case turnEnded
        case damaged
        case damagedWith(String)
        case damagedLethal
        case eliminated
        case handEmpty
        case otherEliminated
        case otherDamaged
        case playedCardOutOfTurn
        case cardPlayedWithName(String)
        case cardPlayedWithAttr(PlayerAttribute)
        case damagingWith(String)
    }

    public init(
        when: PlayerEvent,
        action: GameAction,
        selectors: [Selector]? = nil
    ) {
        self.when = when
        self.action = action
        self.selectors = selectors
    }
}

public enum PlayerAttribute: String, Codable {
    case maxHealth
    case drawCards
    case weapon
    case magnifying
    case remoteness
    case handLimit

    // ⚠️ related to specific card
    case playBangWithMissed
    case playBangWithAny
    case playMissedWithBang
    case playMissedWithAny
    case silentCardsDiamonds
    case silentCardsInPlayDuringTurn
}

public enum EffectAttribute: String, Codable {
    case bangLimitPerTurn
    case bangRequiredMisses
    case bangDamage
    case startTurnCards
}

/// An action is some kind of change
/// Triggered by user or by the system, that causes any update to the game state
public enum GameAction: String, Codable {
    /// {actor} plays a {card}
    case play

    /// {target or actor} increase health by {amount}
    case heal

    /// {target or actor} decrease health by {amount}
    case damage

    /// {actor} draw the top deck card
    case drawDeck

    /// {target or actor} discard a {card}
    case discard

    /// {actor} discard silently a {card}
    case discardSilently

    /// {actor} steal a {card} from {target}
    case steal

    /// {actor} put a {card} on {target}'s inPlay
    case handicap

    /// {actor} shoot at {target} with {damage} and {requiredMisses}
    /// By default damage is 1
    /// By default requiredMisses is 1
    case shoot

    /// {actor} counter a shot applied on himself
    case missed

    /// {target} choose a {card} from choosable cards
    case chooseCard

    /// {actor} equip with a {card}
    case equip

    /// {actor} passes his {card} to {target}'s inPlay
    case pass

    /// expose {amount} choosable cards from top deck
    case reveal

    /// draw cards from deck. Next effects depend it
    case draw

    /// {actor} ends his turn
    case endTurn

    /// {target} starts his turn
    case startTurn

    /// {actor} gets eliminated
    case eliminate

    /// {actor} shows his last drawn card
    case showLastDraw

    /// {actor} draws the last discarded card
    case drawDiscard

    // MARK: ``Reversible``applied when card is played and reversed when card is discarded

    /// {actor} set his {attribute} to {value}
    case setAttribute

    /// {actor} increase his {attribute} by {value}
    case incrementAttribute
}