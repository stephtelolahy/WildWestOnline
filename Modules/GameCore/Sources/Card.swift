//
//  Card.swift
//
//  Created by Hugues Telolahy on 28/10/2024.
//

/// We are working on a Card Definition DSL that will allow people to create new cards,
/// not currently in the game and see how they play.
/// A `card` is just a collection of effects and attributes
/// ℹ️ Inspired by https://github.com/danielyule/hearthbreaker/wiki/Tag-Format
///
public struct Card: Equatable, Sendable {
    public let name: String
    public let type: CardType
    public let description: String?
    public let effects: [Effect]

    public init(
        name: String,
        type: CardType,
        description: String? = nil,
        effects: [Effect] = []
    ) {
        self.name = name
        self.type = type
        self.description = description
        self.effects = effects
    }

    public enum CardType: String, Sendable {
        case collectible
        case figure
        case ability
    }

    public struct Effect: Equatable, Sendable {
        public let trigger: Trigger
        public let action: ActionName
        public let amount: Int?
        public let amountPerTurn: [String: Int]?
        public let alias: PlayedCardAlias?
        public let selectors: [Selector]

        public init(
            trigger: Trigger,
            action: ActionName,
            amount: Int? = nil,
            amountPerTurn: [String: Int]? = nil,
            alias: PlayedCardAlias? = nil,
            selectors: [Selector] = []
        ) {
            self.trigger = trigger
            self.action = action
            self.amount = amount
            self.amountPerTurn = amountPerTurn
            self.alias = alias
            self.selectors = selectors
        }
    }

    public enum Trigger: Equatable, Sendable {
        case permanent
        case prePlayed
        case played
        case equiped
        case discarded
        case damaged
        case lethallyDamaged
        case eliminated
        case handEmptied
        case turnStarted
        case turnEnded
        case shot
        case eliminatingOther
        case otherEliminated
        case drawLastCardOnTurnStarted
        case weaponPlayAttempted
        case shootingWithCard(named: String)
        case prePlayingCard(named: String)
        case drawRequired
        case hasStealHandOnTurnStarted
        case hasDrawDiscardOnTurnStarted
    }

    public enum ActionName: String, Sendable {
        case preparePlay
        case play
        case equip
        case handicap
        case draw
        case discover
        case undiscover
        case drawDeck
        case drawDiscard
        case drawDiscovered
        case stealHand
        case stealInPlay
        case discardHand
        case discardInPlay
        case passInPlay
        case showHand
        case heal
        case damage
        case shoot
        case counterShot
        case endTurn
        case startTurn
        case eliminate
        case endGame
        case activate
        case choose
        case increaseMagnifying
        case increaseRemoteness
        case setWeapon
        case setMaxHealth
        case setAlias
        case incrementRequiredMisses
        case ignoreLimitPerTurn
        case incrementCardsPerTurn

        // MARK: Invisible
        case queue
        case discard
        case steal
    }

    public enum Selector: Equatable, Sendable {
        case `repeat`(RepeatCount)
        case forEachTarget(PlayerGroup)
        case setTarget(PlayerRef)
        case forEachCard(CardGroup)
        case setCard(CardRef)
        case chooseOne(ChoiceKind, prompt: ChoicePrompt? = nil, selection: String? = nil)
        case require(PlayRequirement)
        case applyIf(PlayRequirement)

        public enum RepeatCount: Equatable, Sendable {
            case times(Int)
            case perPlayer
            case perExcessHand
            case perDamage
            case perRequiredMisses
        }

        public enum PlayerGroup: Equatable, Sendable {
            case all
            case wounded
            case others([PlayerFilter] = [])
        }

        public enum PlayerRef: Equatable, Sendable {
            case next
            case attacker
            case source
            case eliminated
        }

        public enum CardGroup: String, Sendable {
            case all
        }

        public enum CardRef: String, Sendable {
            case played
            case equippedWeapon
            case lastDrawn
        }

        public indirect enum PlayRequirement: Equatable, Sendable {
            case not(Self)
            case playersAtLeast(Int)
            case playLimit(Int)
            case isHealthZero
            case isGameOver
            case isMyTurn
            case drawMatches(_ regex: String)
            case lastDrawnMatches(_ regex: String)
        }

        public enum ChoiceKind: Equatable, Sendable {
            case targetPlayer([PlayerFilter] = [])
            case targetCard([CardFilter] = [])
            case discoverCard
            case discardedCard
            case costCard([CardFilter] = [])
            case counterCard([CardFilter] = [])
            case redirectCard([CardFilter] = [])
            case playedCard([CardFilter] = [])
        }

        public enum PlayerFilter: Equatable, Sendable {
            case hasCards
            case hasHandCards
            case atDistance(Int)
            case reachable
            case isWounded
        }

        public enum CardFilter: Equatable, Sendable {
            case canCounterShot
            case named(String)
            case fromHand
        }

        public struct ChoicePrompt: Equatable, Sendable {
            public let chooser: String
            public let options: [Option]

            public init(chooser: String, options: [Option]) {
                self.chooser = chooser
                self.options = options
            }

            public struct Option: Equatable, Sendable {
                public let id: String
                public let label: String

                public init(id: String, label: String) {
                    self.id = id
                    self.label = label
                }
            }
        }
    }

    public struct PlayedCardAlias: Equatable, Sendable {
        public let played: String
        public let alias: String

        public init(played: String, alias: String) {
            self.played = played
            self.alias = alias
        }
    }
}

public extension String {
    static let choiceHiddenHand = "hiddenHand"
    static let choicePass = "pass"
}
