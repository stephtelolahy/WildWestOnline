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
        case player(Player)
        /// determine targetted card
        case card(Card)
        /// determine a card or ignore effect
        case cardOrIgnore(Card)
        /// determine affected attribute
        case attribute(PlayerAttribute)
        /// determine amount
        case amount(Number)
        /// determine additional misses
        case additionalRequiredMisses(Number)

        /// will apply effect x times
        case `repeat`(Number)
        /// must match given condition
        case `if`(StateCondition)
        /// must discard card(s)
        case cost(Card, count: Int = 1)
        /// can counter effect by discarding a card
        case counterWith(Card)
        /// can reverse effect by discarding a card
        case reverseWith(Card)

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
                case named(String)
                case action(GameAction)
            }
        }

        public enum Number: Equatable, Codable {
            case activePlayers
            case excessHand
            case damage
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
        case permanent // applied when card is played and reversed when card is discarded
        case cardPlayed
        case shot
        case turnStarted
        case turnEnded
        case damaged
        case damagedLethal
        case eliminated
        case weaponPlayed
        case handEmpty
        case otherEliminated
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

    // ⚠️ attributes related to specific card
    case startTurn_cards
    case bang_additionalRequiredMisses
    case bang_limitPerTurn
    case bang_playAsMissedAndViceVersa
}
