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
        case player(Player)
        case card(Card)
        case cardOrIgnore(Card)
        case amount(Number)
        case `repeat`(Number)
        case `if`(StateCondition)
        case counterWith(Card)
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
            case value(Int)
        }

        public enum StateCondition: Equatable, Codable {
            case playersAtLeast(Int)
            case cardPlayedLessThan(Number)
            case draw(String)
            case notDraw(String)
            case actorTurn
            case noHealth
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
        case handEmpty
        case otherEliminated
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

public enum PlayerAttribute: String, Codable {
    case requiredMissesForBang
    case startTurnCards
    case bangLimitPerTurn
    case weapon
}
