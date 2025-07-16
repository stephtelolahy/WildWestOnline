//
//  Card.swift
//
//  Created by Hugues Telolahy on 28/10/2024.
//
// swiftlint:disable nesting

import Redux

/// We are working on a Card Definition DLS that will allow people to create new cards,
/// not currently in the game and see how they play.
/// A `card` is just a collection of effects and attributes
/// ℹ️ Inspired by https://github.com/danielyule/hearthbreaker/wiki/Tag-Format
///
public struct Card: Equatable, Codable, Sendable {
    public let name: String
    public let type: CardType
    public let description: String
    public let canPlay: [PlayCondition]
    public let onPreparePlay: [Effect]
    public let onPlay: [Effect]
    public let canTrigger: [TriggerCondition]
    public let onTrigger: [Effect]
    public let onActive: [Effect]
    public let onInactive: [Effect]
    public let canCounterShot: Bool

    public init(
        name: String,
        type: CardType,
        description: String = "",
        canPlay: [PlayCondition] = [],
        onPreparePlay: [Effect] = [],
        onPlay: [Effect] = [],
        canTrigger: [TriggerCondition] = [],
        onTrigger: [Effect] = [],
        onActive: [Effect] = [],
        onInactive: [Effect] = [],
        canCounterShot: Bool = false
    ) {
        self.name = name
        self.type = type
        self.description = description
        self.canPlay = canPlay
        self.onPreparePlay = onPreparePlay
        self.onPlay = onPlay
        self.canTrigger = canTrigger
        self.onTrigger = onTrigger
        self.onActive = onActive
        self.onInactive = onInactive
        self.canCounterShot = canCounterShot
    }

    public enum CardType: Equatable, Codable, Sendable {
        case brown
        case blue
        case character
        case ability
    }

    public struct Effect: ActionProtocol, Equatable, Codable {
        public let name: Name
        public var payload: Payload
        public var selectors: [Card.Selector]
        public let triggeredByName: Name?
        public let triggeredByPayload: Payload?

        public enum Name: String, Codable, Sendable {
            case preparePlay
            case play
            case equip
            case handicap
            case draw
            case discover
            case drawDeck
            case drawDiscard
            case drawDiscovered
            case stealHand
            case stealInPlay
            case discardHand
            case discardInPlay
            case passInPlay
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
            case setHandLimit
            case setPlayLimitPerTurn
            case setDrawCards
            case queue
        }

        public struct Payload: Equatable, Codable, Sendable {
            public let player: String
            public let playedCard: String
            public var targetedPlayer: String?
            public var targetedCard: String?
            public var amount: Int?
            public var chosenOption: String?
            public var nestedEffects: [Effect]?
            public var affectedCards: [String]?
            public var amountPerTurn: [String: Int]?

            public init(
                player: String = "",
                playedCard: String = "",
                targetedPlayer: String? = nil,
                targetedCard: String? = nil,
                amount: Int? = nil,
                chosenOption: String? = nil,
                nestedEffects: [Card.Effect]? = nil,
                affectedCards: [String]? = nil,
                amountPerTurn: [String: Int]? = nil
            ) {
                self.player = player
                self.playedCard = playedCard
                self.targetedPlayer = targetedPlayer
                self.targetedCard = targetedCard
                self.amount = amount
                self.chosenOption = chosenOption
                self.nestedEffects = nestedEffects
                self.affectedCards = affectedCards
                self.amountPerTurn = amountPerTurn
            }
        }

        public init(
            name: Name,
            payload: Payload = .init(),
            selectors: [Card.Selector] = [],
            triggeredByName: Name? = nil,
            triggeredByPayload: Payload? = nil
        ) {
            self.name = name
            self.selectors = selectors
            self.payload = payload
            self.triggeredByName = triggeredByName
            self.triggeredByPayload = triggeredByPayload
        }

        public func copy(
            withPlayer player: String? = nil,
            playedCard: String? = nil,
            targetedPlayer: String? = nil,
            targetedCard: String? = nil,
            amount: Int? = nil,
            selectors: [Card.Selector]? = nil,
            triggeredByName: Name? = nil,
            triggeredByPayload: Payload? = nil
        ) -> Self {
            .init(
                name: self.name,
                payload: .init(
                    player: player ?? self.payload.player,
                    playedCard: playedCard ?? self.payload.playedCard,
                    targetedPlayer: targetedPlayer ?? self.payload.targetedPlayer,
                    targetedCard: targetedCard ?? self.payload.targetedCard,
                    amount: amount ?? self.payload.amount,
                    chosenOption: self.payload.chosenOption,
                    nestedEffects: self.payload.nestedEffects,
                    affectedCards: self.payload.affectedCards,
                    amountPerTurn: self.payload.amountPerTurn
                ),
                selectors: selectors ?? self.selectors,
                triggeredByName: triggeredByName ?? self.triggeredByName,
                triggeredByPayload: triggeredByPayload ?? self.triggeredByPayload
            )
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            NonStandardLogic.areActionsEqual(lhs, rhs)
        }
    }

    public enum PlayCondition: Equatable, Codable, Sendable {
        case minimumPlayers(Int)
        case playLimitPerTurn([String: Int])
        case isHealthZero
        case isHealthNonZero
        case isGameOver
        case isCurrentTurn
        case drawnCardMatches(_ regex: String)
        case drawnCardDoesNotMatch(_ regex: String)
        case payloadCardFromTargetHand
        case payloadCardFromTargetInPlay
    }

    public struct TriggerCondition: Equatable, Codable, Sendable {
        public let name: Card.Effect.Name
        public let conditions: [PlayCondition]

        public init(
            name: Effect.Name,
            conditions: [PlayCondition] = []
        ) {
            self.name = name
            self.conditions = conditions
        }
    }

    public enum Selector: Equatable, Codable, Sendable {
        case `repeat`(Number)
        case setTarget(TargetGroup)
        case setCard(CardGroup)
        case chooseOne(ChoiceRequirement, resolved: ChoicePrompt? = nil, selection: String? = nil)
        case require(PlayCondition)

        public enum Number: Equatable, Codable, Sendable {
            case value(Int)
            case activePlayerCount
            case playerExcessHandSize
            case drawnCardCount
            case receivedDamageAmount
        }

        public enum TargetGroup: String, Codable, Sendable {
            case activePlayers
            case woundedPlayers
            case otherPlayers
            case nextPlayer
        }

        public enum CardGroup: String, Codable, Sendable {
            case allInHand
            case allInPlay
            case played
            case equippedWeapon
        }

        public enum ChoiceRequirement: Equatable, Codable, Sendable {
            case target([TargetFilter] = [])
            case targetCard([CardFilter] = [])
            case discoveredCard
            case optionalCounterCard([CardFilter] = [])
            case optionalRedirectCard([CardFilter] = [])
        }

        public enum TargetFilter: Equatable, Codable, Sendable {
            case hasCards
            case atDistance(Int)
            case reachable
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

    public enum PlayError: Error, Equatable, Codable {
        case insufficientDeck
        case insufficientDiscard
        case playerAlreadyMaxHealth(String)
        case noReq(Card.PlayCondition)
        case noTarget(Card.Selector.TargetGroup)
        case noChoosableTarget([Card.Selector.TargetFilter])
        case cardNotPlayable(String)
        case cardAlreadyInPlay(String)
    }
}

public extension String {
    static let choiceHiddenHand = "hiddenHand"
    static let choicePass = "pass"
}

public extension Int {
    static let infinity = 999
}
