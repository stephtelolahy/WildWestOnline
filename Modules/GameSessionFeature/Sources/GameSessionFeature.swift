//
//  GameSessionFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 05/12/2025.
//

import Foundation
import Redux
import CardDefinition
import GameFeature

public enum GameSessionFeature {
    public struct State: Equatable {
        var game: GameFeature.State?

        var players: [Player]
        var message: String
        var chooseOne: ChooseOne?
        var handCards: [HandCard]
        var topDiscard: String?
        var topDeck: String?
        var startOrder: [String]
        var deckCount: Int
        var startPlayer: String
        var actionDelaySeconds: TimeInterval
        var lastEvent: GameFeature.Action?
        var controlledPlayer: String?

        public struct Player: Equatable {
            let id: String
            let imageName: String
            let displayName: String
            let health: Int
            let handCount: Int
            let inPlay: [String]
            let isTurn: Bool
            let isTargeted: Bool
            let isEliminated: Bool
            let role: String?
            let userPhotoUrl: String?
        }

        public struct HandCard: Equatable {
            let card: String
            let active: Bool
        }

        public struct ChooseOne: Equatable {
            let resolvingAction: Card.ActionName
            let chooser: String
            let options: [String]
        }

        public init(
            game: GameFeature.State? = nil,
            players: [Player] = [],
            message: String = "",
            chooseOne: ChooseOne? = nil,
            handCards: [HandCard] = [],
            topDiscard: String? = nil,
            topDeck: String? = nil,
            startOrder: [String] = [],
            deckCount: Int = 0,
            startPlayer: String = "",
            actionDelaySeconds: TimeInterval = 0,
            lastEvent: GameFeature.Action? = nil,
            controlledPlayer: String? = nil
        ) {
            self.game = game
            self.players = players
            self.message = message
            self.chooseOne = chooseOne
            self.handCards = handCards
            self.topDiscard = topDiscard
            self.topDeck = topDeck
            self.startOrder = startOrder
            self.deckCount = deckCount
            self.startPlayer = startPlayer
            self.actionDelaySeconds = actionDelaySeconds
            self.lastEvent = lastEvent
            self.controlledPlayer = controlledPlayer
        }
    }

    public enum Action {
        case onAppear
        case quitTapped
        case settingsTapped

        case game(GameFeature.Action)

        case delegate(Delegate)

        public enum Delegate {
            case quit
            case settings
        }
    }

    public static func reducer(
        state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        .none
    }
}

extension GameSessionFeature.State {
}

//    private static func createGame(state: State, dependencies: Dependencies) -> GameFeature.State {
//        GameSetup.buildGame(
//            playersCount: state.settings.playersCount,
//            cards: dependencies.cardLibrary.cards(),
//            deck: dependencies.cardLibrary.deck(),
//            actionDelayMilliSeconds: state.settings.actionDelayMilliSeconds,
//            preferredFigure: state.settings.preferredFigure,
//            playModeSetup: state.settings.simulation ? .allAuto : .oneManual
//        )
//    }

/*

public extension GameView.ViewState {
    init?(appState: AppFeature.State) {
        guard let game = appState.game else {
            return nil
        }

        players = game.playerItems
        message = game.message
        chooseOne = game.chooseOne
        handCards = game.handCards
        topDiscard = game.discard.first
        topDeck = game.deck.first
        startOrder = game.startOrder
        deckCount = game.deck.count
        controlledPlayer = game.manuallyControlledPlayer()
        startPlayer = game.startPlayerId
        actionDelaySeconds = Double(appState.settings.actionDelayMilliSeconds) / 1000.0
        lastEvent = game.lastEvent
    }
}

private extension GameFeature.State {
    var playerItems: [GameView.ViewState.PlayerItem] {
        self.startOrder.map { playerId in
            let playerObj = players.get(playerId)
            let health = max(0, playerObj.health)
            let handCount = playerObj.hand.count
            let equipment = playerObj.inPlay
            let isTurn = playerId == turn
            let isEliminated = !playOrder.contains(playerId)
            let isTargeted = isTargeted(playerId)
            let name = playerObj.figure.first ?? ""

            return .init(
                id: playerId,
                imageName: name,
                displayName: name.uppercased(),
                health: health,
                handCount: handCount,
                inPlay: equipment,
                isTurn: isTurn,
                isTargeted: isTargeted,
                isEliminated: isEliminated,
                role: nil,
                userPhotoUrl: nil
            )
        }
    }

    var message: String {
        if let turn {
            "\(turn.uppercased())'s turn"
        } else {
            "-"
        }
    }

    var chooseOne: GameView.ViewState.ChooseOne? {
        guard let controlledPlayer = manuallyControlledPlayer(),
              let choice = pendingChoice(for: controlledPlayer) else {
            return  nil
        }

        return .init(
            resolvingAction: choice.action,
            chooser: choice.prompt.chooser,
            options: choice.prompt.options.map(\.label)
        )
    }

    var handCards: [GameView.ViewState.HandCard] {
        guard let controlledPlayer = manuallyControlledPlayer() else {
            return []
        }

        var playableCards: [String] = []
        if let playable,
            playable.player == controlledPlayer {
            playableCards = playable.cards
        }
        let handCards = players.get(controlledPlayer).hand

        let hand = handCards.map { card in
            GameView.ViewState.HandCard(
                card: card,
                active: playableCards.contains(card)
            )
        }

        let abilities = playableCards.compactMap { card in
            if !handCards.contains(card) {
                GameView.ViewState.HandCard(
                    card: card,
                    active: true
                )
            } else {
                nil
            }
        }

        return hand + abilities
    }

    var startingPlayerId: String {
        playOrder.first!
    }

    var startPlayerId: String {
        guard let playerId = startOrder.first else {
            fatalError("Missing start player")
        }

        return playerId
    }
}
*/
