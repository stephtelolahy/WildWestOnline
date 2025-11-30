//
//  Card.swift
//
//  Created by Hugues Telolahy on 28/10/2024.
//

import Redux

/// We are working on a Card Definition DSL that will allow people to create new cards,
/// not currently in the game and see how they play.
/// A `card` is just a collection of effects and attributes
/// ℹ️ Inspired by https://github.com/danielyule/hearthbreaker/wiki/Tag-Format
///
public struct Card: Equatable, Codable, Sendable {
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

    public enum CardType: String, Codable, Sendable {
        case collectible
        case figure
        case ability
    }

    public struct Effect: Equatable, Codable, Sendable {
        public let trigger: Trigger
        public let action: ActionName
        public let modifier: GameFeature.Action.QueueModifier?
        public let amount: Int?
        public let amountPerTurn: [String: Int]?
        public let alias: [String: String]?
        public let selectors: [Selector]

        public init(
            trigger: Trigger,
            action: ActionName,
            modifier: GameFeature.Action.QueueModifier? = nil,
            amount: Int? = nil,
            amountPerTurn: [String: Int]? = nil,
            alias: [String: String]? = nil,
            selectors: [Selector] = []
        ) {
            self.trigger = trigger
            self.action = action
            self.modifier = modifier
            self.amount = amount
            self.amountPerTurn = amountPerTurn
            self.alias = alias
            self.selectors = selectors
        }
    }

    public enum Trigger: Equatable, Codable, Sendable {
        case permanent
        case cardPrePlayed
        case cardPlayed
        case cardEquiped
        case cardDiscarded
        case damaged
        case damagedLethal
        case eliminated
        case handEmptied
        case turnStarted
        case turnEnded
        case shot
        case eliminating
        case otherEliminated
        case drawLastCardOnTurnStarted
        case weaponPrePlayed
        case shootingWithCard(named: String)
        case prePlayingCard(named: String)
        case requiredToDraw
    }

    public enum ActionName: String, Codable, Sendable {
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
        case queue
        case applyModifier
        case dummy
    }

    public enum Selector: Equatable, Codable, Sendable {
        case `repeat`(RepeatCount)
        case setTarget(PlayerGroup)
        case setCard(CardGroup)
        case chooseOne(ChoiceRequirement, prompt: ChoicePrompt? = nil, selection: String? = nil)
        case require(PlayRequirement)
        case applyIf(PlayRequirement)
        case onComplete([Effect])

        public enum RepeatCount: Equatable, Codable, Sendable {
            case fixed(Int)
            case activePlayerCount
            case playerExcessHandSize
            case receivedDamageAmount
            case requiredMisses
        }

        public enum PlayerGroup: Equatable, Codable, Sendable {
            case activePlayers
            case woundedPlayers
            case otherPlayers([PlayerFilter] = [])
            case nextPlayer
            case damagingPlayer
            case sourcePlayer
            case eliminatedPlayer
        }

        public enum CardGroup: String, Codable, Sendable {
            case allInHand
            case allInPlay
            case played
            case equippedWeapon
            case lastHand
        }

        public indirect enum PlayRequirement: Equatable, Codable, Sendable {
            case not(Self)
            case minimumPlayers(Int)
            case playLimitThisTurn(Int)
            case isHealthZero
            case isGameOver
            case isCurrentTurn
            case drawnCardMatches(_ regex: String)
            case lastHandCardMatches(_ regex: String)
            case targetedCardFromHand
            case targetedCardFromInPlay
        }

        public enum ChoiceRequirement: Equatable, Codable, Sendable {
            case targetPlayer([PlayerFilter] = [])
            case targetCard([CardFilter] = [])
            case discoverCard
            case discardedCard
            case costCard([CardFilter] = [])
            case counterCard([CardFilter] = [])
            case redirectCard([CardFilter] = [])
            case playedCard([CardFilter] = [])
        }

        public enum PlayerFilter: Equatable, Codable, Sendable {
            case hasCards
            case hasHandCards
            case atDistance(Int)
            case reachable
            case isWounded
        }

        public enum CardFilter: Equatable, Codable, Sendable {
            case canCounterShot
            case named(String)
            case isFromHand
        }

        public struct ChoicePrompt: Equatable, Codable, Sendable {
            public let chooser: String
            public let options: [Option]

            public init(chooser: String, options: [Option]) {
                self.chooser = chooser
                self.options = options
            }

            public struct Option: Equatable, Codable, Sendable {
                public let id: String
                public let label: String

                public init(id: String, label: String) {
                    self.id = id
                    self.label = label
                }
            }
        }
    }
}

public extension String {
    static let choiceHiddenHand = "hiddenHand"
    static let choicePass = "pass"
}
