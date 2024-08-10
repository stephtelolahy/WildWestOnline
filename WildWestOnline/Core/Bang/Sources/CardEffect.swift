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
        /// determine affected attribute
        case attribute(PlayerAttribute, value: Int)
        /// determine amount
        case amount(Number)
        /// determine required misses for `shoot`
        case requiredMisses(Number)

        /// multiply effect x times
        case `repeat`(Number)
        /// must match given condition
        case `if`(StateCondition)
        /// must discard cards
        case cost(Card)

        /// can discard a card to counter the effect
        case counterCost(Card)
        /// can discard a card to reverse effect
        case reverseCost(Card)

        /// choose a card or skip effect
        case cardOrSkip(Card)
        /// choose to loose one life point or skip effect
        case looseLifePointOrSkip

        public enum Player: Equatable, Codable {
            case actor
            case all
            case others
            case next
            case offender
            case eliminated
            case any([Condition]? = nil)

            public enum Condition: Equatable, Codable {
                case atDistance(Number)
                case havingCard(Card.Condition? = nil)
            }
        }

        public enum Card: Equatable, Codable {
            case played
            case all
            case inPlay(Condition)
            case anyChoosable
            case any([Condition]? = nil)

            public enum Condition: Equatable, Codable {
                case fromHand
                case inPlay
                case named(String)
                case isBlue
                case action(GameAction)
                case attr(PlayerAttribute)
            }
        }

        public enum Number: Equatable, Codable {
            case activePlayers
            case excessHand
            case damage // damage compared to maxHealth
            case lastDamage // amount from last damage event
            case remainingStartTurnCards
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

    public indirect enum PlayerEvent: Equatable, Codable {
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
        case cardPlayed(Selector.Card.Condition)
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
    case bangRequiredMisses
    case bangLimitPerTurn
    case bangWithMissed
    case missedWithBang
    case missedWithAny
    case silentCardsDiamonds
    case silentCardsInPlayDuringTurn
}
