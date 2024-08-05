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
    public let until: PlayerEvent?

    /// Selectors are used to specify which objects an aura or effect should affect.
    /// Choice is performed by {actor}
    public enum Selector: Equatable, Codable {
        case player(Player, conditions: [PlayerCondition]? = nil)
        case card(Card, conditions: [CardCondition]? = nil)
        case amount(Number)
        case `repeat`(Number)
        case `if`(StateCondition)
        case counterCard(Card, conditions: [CardCondition]? = nil)
        case reverseCard(Card, conditions: [CardCondition]? = nil)
        case activeCard(Card, conditions: [CardCondition]? = nil)

        public enum Player: String, Codable {
            case actor
            case all
            case others
            case next
            case offender
            case any
        }

        public enum Card: String, Codable {
            case played
            case all
            case previousWeapon
            case any
            case anyChoosable
        }

        public enum StateCondition: String, Codable {
            case playersAtLeast3
            case cardPlayedLessThanBangLimitPerTurn
            case drawHearts
            case notDrawHearts
            case drawsSpades
            case notDrawsSpades
            case isYourTurn
        }

        public enum PlayerCondition: String, Codable {
            case damaged
            case havingCard
            case atDistance1
            case atDistanceReachable
        }

        public enum CardCondition: String, Codable {
            case handCardNamedBang
            case handCardNamedMissed
            case handCardNamedBeer
            case handCard
        }

        public enum Number: Equatable, Codable {
            case value(Int)
            case activePlayers
            case requiredMissesForBang
            case excessHand
            case startTurnCards
            case damage
        }
    }

    public indirect enum PlayerEvent: String, Codable {
        case cardPlayed
        case shot
        case turnStarted
        case turnEnded
        case cardDiscarded
        case damaged
        case damagedLethal
        case eliminated
        case weaponPlayed
    }

    public init(
        action: GameAction,
        selectors: [Selector]? = nil,
        when: PlayerEvent,
        until: PlayerEvent? = nil
    ) {
        self.when = when
        self.action = action
        self.selectors = selectors
        self.until = until
    }
}
