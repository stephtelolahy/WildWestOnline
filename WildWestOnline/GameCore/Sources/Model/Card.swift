//
//  swift
//
//  Created by Hugues Telolahy on 28/10/2024.
//

import Redux

/// We are working on a Card Definition DLS that will allow people to create new cards,
/// not currently in the game and see how they play.
/// A `card` is just a collection of effects and attributes
/// ℹ️ Inspired by https://github.com/danielyule/hearthbreaker/wiki/Tag-Format
///
public struct Card: Equatable, Codable, Sendable {
    public let name: String
    public let type: CardType
    public let description: String?
    public let behaviour: [Trigger: [Effect]]

    public init(
        name: String,
        type: CardType,
        description: String? = nil,
        behaviour: [Trigger: [Effect]] = [:]
    ) {
        self.name = name
        self.type = type
        self.description = description
        self.behaviour = behaviour
    }

    public enum CardType: Equatable, Codable, Sendable {
        case brown
        case blue
        case character
        case ability
    }

    public struct Effect: ActionProtocol, Equatable, Codable {
        public let name: Name

        public let sourcePlayer: String
        public let playedCard: String
        public let triggeredBy: [Self]

        public var targetedPlayer: String?
        public var targetedCard: String?
        public var amount: Int?
        public var chosenOption: String?
        public var nestedEffects: [Self]?
        public var affectedCards: [String]?
        public var amountPerTurn: [String: Int]?

        public var selectors: [Selector]

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

        public init(
            name: Name,
            sourcePlayer: String = "",
            playedCard: String = "",
            triggeredBy: [Self] = [],
            targetedPlayer: String? = nil,
            targetedCard: String? = nil,
            amount: Int? = nil,
            chosenOption: String? = nil,
            nestedEffects: [Self]? = nil,
            affectedCards: [String]? = nil,
            amountPerTurn: [String: Int]? = nil,
            selectors: [Selector] = []
        ) {
            self.name = name
            self.selectors = selectors
            self.sourcePlayer = sourcePlayer
            self.playedCard = playedCard
            self.triggeredBy = triggeredBy
            self.targetedPlayer = targetedPlayer
            self.targetedCard = targetedCard
            self.amount = amount
            self.chosenOption = chosenOption
            self.nestedEffects = nestedEffects
            self.affectedCards = affectedCards
            self.amountPerTurn = amountPerTurn
        }

        public func copy(
            withPlayer sourcePlayer: String? = nil,
            playedCard: String? = nil,
            triggeredBy: [Self]? = nil,
            targetedPlayer: String? = nil,
            targetedCard: String? = nil,
            amount: Int? = nil,
            selectors: [Selector]? = nil,
        ) -> Self {
            .init(
                name: self.name,
                sourcePlayer: sourcePlayer ?? self.sourcePlayer,
                playedCard: playedCard ?? self.playedCard,
                triggeredBy: triggeredBy ?? self.triggeredBy,
                targetedPlayer: targetedPlayer ?? self.targetedPlayer,
                targetedCard: targetedCard ?? self.targetedCard,
                amount: amount ?? self.amount,
                chosenOption: self.chosenOption,
                nestedEffects: self.nestedEffects,
                affectedCards: self.affectedCards,
                amountPerTurn: self.amountPerTurn,
                selectors: selectors ?? self.selectors
            )
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            NonStandardLogic.areActionsEqual(lhs, rhs)
        }
    }

    public enum Trigger: Equatable, Codable, Sendable {
        case permanent
        case cardEquiped
        case cardDiscarded
        case damaged
        case damagedLethal
        case eliminated
        case handEmptied
        case turnStarted
        case turnEnded
        case shot
        case cardPrePlayed
        case cardPlayed
    }

    public enum Selector: Equatable, Codable, Sendable {
        case `repeat`(Number)
        case setTarget(TargetGroup)
        case setCard(CardGroup)
        case chooseOne(ChoiceRequirement, resolved: ChoicePrompt? = nil, selection: String? = nil)
        case require(StateCondition)
        case requireThrows(StateCondition)

        public enum Number: Equatable, Codable, Sendable {
            case fixed(Int)
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
            case damagingPlayer
        }

        public enum CardGroup: String, Codable, Sendable {
            case allInHand
            case allInPlay
            case played
            case equippedWeapon
        }

        public enum StateCondition: Equatable, Codable, Sendable {
            case minimumPlayers(Int)
            case playLimitPerTurn([String: Int])
            case isGameOver
            case isCurrentTurn
            case drawnCardMatches(_ regex: String)
            case drawnCardDoesNotMatch(_ regex: String)
            case targetedCardFromHand
            case targetedCardFromInPlay
            case targetedPlayerHasHandCard
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
        case noReq(Selector.StateCondition)
        case noTarget(Selector.TargetGroup)
        case noChoosableTarget([Selector.TargetFilter])
        case cardNotPlayable(String)
        case cardAlreadyInPlay(String)
    }
}

public extension String {
    static let choiceHiddenHand = "hiddenHand"
    static let choicePass = "pass"
}

public extension Int {
    static let unlimited = 999
}
