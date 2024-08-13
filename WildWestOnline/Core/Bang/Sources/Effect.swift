//  Effect.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 28/07/2024.
//
// swiftlint:disable type_contents_order discouraged_optional_collection nesting identifier_name

/// An `effect` is a tag which performs an `action` each time an `event` occurs.
public struct Effect: Equatable, Codable {
    public let when: PlayerEvent
    public let action: Action
    public let selectors: [Selector]?

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
        /// a player has stolen card of actor
        case cardStolen
        /// a player has discarded a card of actor
        case cardDiscarded
        case cardPlayedWithName(String)
        case cardPlayedWithAttr(PlayerAttribute)
        case damagingWith(String)
        case missed(String)
        case otherPlayedCardWithName(String)
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

        @available(*, deprecated, renamed: "attributes")
        case attr(PlayerAttribute, value: Int)

        /// determine other action arguments
        case arg(Action.Argument, value: Number)
        @available(*, deprecated, renamed: "overrides")
        case overrideArg(Action.Argument, value: Int, card: String)

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
            case action(Action)
            case revealed
        }

        public enum Number: Equatable, Codable {
            case activePlayers
            case excessHand
            case damage // damage compared to maxHealth
            case lastDamage // amount from last damage event
            case playerAttr(PlayerAttribute)
            case add(Int, attr: PlayerAttribute)
            case arg(Action.Argument)
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

    public init(
        when: PlayerEvent,
        action: Action,
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
    case silentCardsDiamonds
    case silentCardsInPlayDuringTurn

    // ⚠️ related to specific card
    case playBangWithAny
}
