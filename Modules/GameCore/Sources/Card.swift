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
    public let type: CardType // kind: Card.Kind
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
        case collectible    // action
        case figure         // character
        case ability        // rule: These are implicit game rules, not something you "activate"
    }

    public struct Effect: Equatable, Sendable {
        public let actionID: ActionID   // id
        public let trigger: Trigger     // event
        @available(*, deprecated, message: "Use actionID instead")
        public let action: ActionName?
        public let amount: Int?
        public let amountPerTurn: [String: Int]?
        public let alias: [String: String]? // aliases
        public let selectors: [Selector]

        public init(
            // swiftlint:disable:next function_default_parameter_at_end
            actionID: ActionID = .init(rawValue: "undefined"),
            on trigger: Trigger,
            action: ActionName? = nil,
            amount: Int? = nil,
            amountPerTurn: [String: Int]? = nil,
            alias: [String: String]? = nil,
            selectors: [Selector] = []
        ) {
            self.actionID = actionID
            self.trigger = trigger
            self.action = action
            self.amount = amount
            self.amountPerTurn = amountPerTurn
            self.alias = alias
            self.selectors = selectors
        }
    }

    public enum Trigger: Equatable, Sendable {
        case permanent      // always
        case cardPrePlayed  // playAttempted
        case cardPlayed     // played
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
        case otherEliminated
        case drawLastCardOnTurnStarted
        case weaponPrePlayed                    // weaponPlayAttempted
        case shootingWithCard(named: String)    // shootingWith
        case prePlayingCard(named: String)      // attemptingPlay
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
        case stealHand
        case stealInPlay
        case discardHand
        case discardInPlay
        case passInPlay
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
        case queue
    }

    public enum Selector: Equatable, Sendable {
        case `repeat`(RepeatCount)
        case forEachTarget(PlayerGroup)
        case setTarget(PlayerIdentity)
        case forEachCard(CardGroup)
        case setCard(CardIdentity)
        case chooseOne(ChoiceKind, prompt: ChoicePrompt? = nil, selection: String? = nil) // choose
        case require(PlayRequirement)
        case applyIf(PlayRequirement) // if, when
        @available(*, deprecated, message: "Use `applyIf` instead.")
        case replaceIf(PlayRequirement, Card.ActionName)

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
            case allInHand  // hand
            case allInPlay  // inPlay
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
            case targetedCardFromHand
            case targetedCardFromInPlay
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

    public struct ActionID: RawRepresentable, Hashable, Sendable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

public extension String {
    static let choiceHiddenHand = "hiddenHand"
    static let choicePass = "pass"
}
