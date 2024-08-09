//
//  CardEffect.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 28/07/2024.
//
// swiftlint:disable type_contents_order discouraged_optional_collection nesting identifier_name function_default_parameter_at_end

/// An `effect` is a tag which performs an `action` each time an `event` occurs.
public struct CardEffect: Equatable, Codable {
    public let action: GameAction
    public let selectors: [Selector]?
    public let when: PlayerEvent

    /// Selectors are used to specify which objects an aura or effect should affect.
    /// Choice is performed by {actor}
    public enum Selector: Equatable, Codable {
        /// determine targetted player
        case target(Player)
        /// determine targetted card
        case card(Card)
        /// choose a card or ignore effect
        case cardOrIgnore(Card)
        /// determine affected attribute
        case attribute(PlayerAttribute)
        /// determine amount
        case amount(Number)
        /// determine additional misses
        case additionalRequiredMisses(Number)
        /// choose to loose one life point or ignore effect
        case looseLifePointOrIgnore

        /// multiply effect x times
        case `repeat`(Number)
        /// must match given condition
        case `if`(StateCondition)
        /// must discard card(s)
        case cost(Card, count: Int = 1)
        /// can discard a card to counter the effect
        case counterCost(Card)
        /// can discard a card to reverse effect
        case reverseCost(Card)

        public enum Player: Equatable, Codable {
            case actor
            case all
            case others
            case next
            case offender
            case eliminated
            case any([Condition]? = nil)

            public enum Condition: Equatable, Codable {
                case havingCard
                case havingHandCard
                case havingInPlayCard
                case atDistance(Number)
            }
        }

        public enum Card: Equatable, Codable {
            case played
            case all
            case previousWeapon
            case anyChoosable
            case any([Condition]? = nil)

            public enum Condition: Equatable, Codable {
                case fromHand
                case inPlay
                case named(String)
                case isBlue
                case action(GameAction)
            }
        }

        public enum Number: Equatable, Codable {
            case activePlayers
            case excessHand
            case damage
            case lastDamage // damage amount from last event
            case attr(PlayerAttribute)
            case add(Int, attr: PlayerAttribute)
            case value(Int)
        }

        public indirect enum StateCondition: Equatable, Codable {
            case playersAtLeast(Int)
            case playedLessThan(Number)
            case draw(String)
            case actorTurn
            case not(Self)
        }
    }

    public indirect enum PlayerEvent: String, Codable {
        case played
        case shot
        case turnStarted
        case turnEnded
        case damaged
        case damagedLethal
        case eliminated
        case handEmpty
        case otherEliminated
        case playedCardOutOfTurn

        // ⚠️ related to specific card
        case weaponPlayed
        case beerPlayed
    }

    public init(
        action: GameAction,
        selectors: [Selector]? = nil,
        when: PlayerEvent
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
    case startTurnCards
    case bangAdditionalRequiredMisses
    case bangLimitPerTurn
    case bangWithMissedAndViceVersa
    case missedWithAnyCard
    case silentDiamondsCard
    case silentCardsInPlayDuringTurn
}
