//
//  Card.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 22/07/2024.
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

    public enum ActionType: String, Codable {
        /// {actor} discard silently a {card}
        case playBrown

        /// {actor} put a {card} is self's inPlay
        case playEquipment

        /// {actor} put a {card} on {target}'s inPlay
        case playHandicap

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

        /// {actor} draws the last discarded card
        /// When a {card} is specified, this allow to draw a specific card
        case drawDiscard

        /// {actor} steal a {card} from {target}
        case steal

        /// {target} discard a {card}
        /// By default target is {actor}
        case discard

        /// {actor} pass inPlay {card} on {target}'s inPlay
        case passInPlay

        /// draw {drawCards} cards from deck. Next effects depend on it
        case draw

        /// {actor} shows his last drawn card
        case showLastHand

        /// expose {amount} choosable cards from top deck
        case discover

        /// draw discovered deck {card}
        case drawDiscovered

        /// hide discovered cards
        case undiscover

        /// {target} starts his turn
        case startTurn

        /// {actor} ends his turn
        case endTurn

        /// {actor} gets eliminated
        case eliminate

        // MARK: - To spec

        /// {actor} shoot at {target} with {damage} and {requiredMisses}
        /// By default damage is 1
        /// By default requiredMisses is 1
        case shoot

        /// {actor} counter a shot applied on himself
        case missed

        /// Counter card effect targetting self
        case counter
    }

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
        case chooseTarget([TargetCondition] = [])

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

        public enum Error: Swift.Error, Equatable {
            case noPlayer(Target)
        }
    }

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
        selectors: [Selector] = [],
        when: PlayReq = .played
    ) {
        self.action = action
        self.selectors = selectors
        self.when = when
    }
}

@available(*, deprecated, message: "replace with player property")
public enum PlayerAttribute: String, Codable, CaseIterable {
    case maxHealth
    case weapon
    case magnifying
    case remoteness

    /// maximum hand cards at end of turn
    case handLimit

    /// flipped cards on draw
    case flippedCards

    /// player cannot be killed but leave the game immediately after his turn
    case ghost
}

@available(*, deprecated, message: "replace with player property")
public enum ActionAttribute: String, Codable {
    case healAmount
    case damageAmount
    case discoverAmount
    case drawAmount
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
