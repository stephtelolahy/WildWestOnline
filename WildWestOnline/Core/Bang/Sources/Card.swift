//
//  Card.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 20/10/2024.
//
// swiftlint:disable nesting

/// We are working on a Card Definition Language
/// that will allow people to create new cards,
/// not currently in the game and see how they play.
/// Convincend by DDD way we try to transpose domain language to card scripting
/// ℹ️ Inspired by https://github.com/danielyule/hearthbreaker/wiki/Tag-Format
///
public struct Card: Codable, Equatable {
    public let name: String
    public let desc: String
    public let passive: [PassiveAbility]
    public let triggered: [TriggeredAbility]

    public init(
        name: String,
        desc: String = "",
        passive: [PassiveAbility] = [],
        triggered: [TriggeredAbility] = []
    ) {
        self.name = name
        self.desc = desc
        self.passive = passive
        self.triggered = triggered
    }
}

public enum PassiveAbility: Codable, Equatable {
    case setMaxHealth(Int)
    case setWeapon(Int)
}

public struct TriggeredAbility: Equatable, Codable {
    public let action: ActionType
    public var selectors: [Selector]
    public let when: PlayReq

    /// Selectors are used to specify which objects an aura or effect should affect.
    /// Choice is performed by {actor}
    public enum Selector: Equatable, Codable {
        /// set targetted player
        case setTarget(Target)

        /// set affected card
        case setCard(Card)

        /// choose targeted player
        case chooseTarget([TargetCondition] = [])

        /// choose used card
        case chooseCard(CardCondition? = nil)

        /// choose a hand card to `discard`
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

        public enum Error: Swift.Error, Equatable {
            case noPlayer(Target)
        }
    }

    public indirect enum PlayReq: Equatable, Codable {
        // events on actor
        case played
        case playedCardOutOfTurn
        case playedCardWithName(String)
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
        selectors: [Selector] = [],
        when: PlayReq = .played
    ) {
        self.action = action
        self.selectors = selectors
        self.when = when
    }
}
