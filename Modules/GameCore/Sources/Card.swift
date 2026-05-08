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
        case cardPrePlayed  // playAttempted
        case played
        case cardEquiped    // equipped
        case cardDiscarded  // discarded
        case damaged
        case damagedLethal  // lethallyDamaged
        case eliminated
        case handEmptied
        case turnStarted
        case turnEnded
        case shot
        case eliminating    // eliminatingOther
        case otherEliminated    // anotherPlayerEliminated
        case drawLastCardOnTurnStarted
        case weaponPrePlayed                    // weaponPlayAttempted
        case shootingWithCard(named: String)    // shooting(withCard:)
        case prePlayingCard(named: String)      // attemptingPlay(card:)
        case requiredToDraw                     // drawRequired
        case hasStealHandOnTurnStarted          // stoleFromHandOnTurnStarted
        case hasDrawDiscardOnTurnStarted        // drewFromDiscardOnTurnStarted
    }

    public enum ActionName: String, Sendable {
        case preparePlay
        case play
        case equip
        case handicap
        case draw
        case discover
        case undiscover
        case drawDeck       // drawFromDeck
        case drawDiscard    // drawFromDiscard
        case drawDiscovered // drawFromDiscovered
        case stealHand      // stealFromHand
        case stealInPlay    // stealFromField
        case discardHand
        case discardInPlay
        case passInPlay     // passLeft
        case showHand       // revealCard
        case heal
        case damage
        case shoot          // dodge
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
        case setTarget(PlayerIdentity)
        case forEachCard(CardGroup)
        case setCard(CardIdentity)
        case chooseOne(ChoiceKind, prompt: ChoicePrompt? = nil, selection: String? = nil) // choose
        case require(PlayRequirement)
        case applyIf(PlayRequirement) // when

        public enum RepeatCount: Equatable, Sendable {
            case times(Int)
            case activePlayerCount // perPlayer
            case playerExcessHandSize // perExcessHand
            case receivedDamageAmount   // perDamage
            case requiredMisses // perRequiredMisses
        }

        public enum PlayerGroup: Equatable, Sendable {
            case activePlayers      // all
            case woundedPlayers     // wounded
            case otherPlayers([PlayerFilter] = [])  // others
        }

        public enum PlayerIdentity: Equatable, Sendable { // PlayerRef
            case nextPlayer         // next
            case damagingPlayer     // attacker
            case sourcePlayer       // self
            case eliminatedPlayer   // eliminated
        }

        public enum CardGroup: String, Sendable {
            case all
        }

        public enum CardIdentity: String, Sendable {
            case played // this
            case equippedWeapon // weapon
            case lastHand   // lastDrawn
        }

        public indirect enum PlayRequirement: Equatable, Sendable {
            case not(Self)
            case minimumPlayers(Int)    // playersAtLeast
            case playLimitThisTurn(Int) // playLimit
            case isHealthZero           // isDead
            case isGameOver             // gameOver
            case isMyTurn
            case drawnCardMatches(_ regex: String) // drawMatches
            case lastHandCardMatches(_ regex: String) // lastDrawnMatches
        }

        public enum ChoiceKind: Equatable, Sendable {   // Choice
            case targetPlayer([PlayerFilter] = [])
            case targetCard([CardFilter] = [])
            case discoverCard
            case discardedCard
            case costCard([CardFilter] = [])
            case counterCard([CardFilter] = [])
            case redirectCard([CardFilter] = [])
            case playedCard([CardFilter] = [])  // playableCard
        }

        public enum PlayerFilter: Equatable, Sendable {
            case hasCards   // hasAnyCard
            case hasHandCards   // hasHandCard
            case atDistance(Int)
            case reachable
            case isWounded
        }

        public enum CardFilter: Equatable, Sendable {
            case canCounterShot
            case named(String)
            case isFromHand // fromHand
        }

        public struct ChoicePrompt: Equatable, Sendable { // Prompt
            public let chooser: String // actor
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
