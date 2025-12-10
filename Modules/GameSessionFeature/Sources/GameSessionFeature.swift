//
//  GameSessionFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 05/12/2025.
//

import Foundation
import Redux
import GameCore
import CardLibrary
import PreferencesClient

public enum GameSessionFeature {
    public struct State: Equatable {
        var game: GameFeature.State?

        public init(game: GameFeature.State? = nil) {
            self.game = game
        }
    }

    public enum Action {
        // View
        case didAppear
        case didTapQuit
        case didTapSettings
        case didTapCard(String)
        case didChoose(String, player: String)

        // Internal
        case setGame(GameFeature.State)
        case game(GameFeature.Action)

        // Delegate
        case delegate(Delegate)

        public enum Delegate {
            case quit
            case settings
        }
    }

    public static var reducer: Reducer<State, Action> {
        combine(
            reducerMain,
            reducerSound,
            pullback(
                GameFeature.reducer,
                state: { $0.game != nil ? \.game! : nil },
                action: { if case let .game(action) = $0 { action } else { nil } },
                embedAction: Action.game
            )
        )
    }

    private static func reducerMain(
        into state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        switch action {
        case .didAppear:
            return .run { .setGame(dependencies.createGame()) }

        case .didTapQuit:
            return .run { .delegate(.quit) }

        case .didTapSettings:
            return .run { .delegate(.settings) }

        case .didTapCard(let card):
            guard let controlledPlayer = state.controlledPlayer else {
                return .none
            }
            return .run { .game(.preparePlay(card, player: controlledPlayer)) }

        case .didChoose(let option, let chooser):
            return .run { .game(.choose(option, player: chooser)) }

        case .setGame(let game):
            state.game = game
            return .run { .game(.startTurn(player: game.startOrder[0])) }

        case .game:
            return .none

        case .delegate:
            return .none
        }
    }

    private static func reducerSound(
        into state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        switch action {
        case .game(let gameAction):
            let soundMatcher = SoundMatcher(specialSounds: dependencies.cardLibrary.specialSounds())
            if let sfx = soundMatcher.sfx(on: gameAction) {
                let playFunc = dependencies.audioClient.play
                Task {
                    await playFunc(sfx)
                }
            }
            return .none

        default:
            return .none
        }
    }
}

private extension Dependencies {
    func createGame() -> GameFeature.State {
        GameSetup.buildGame(
            playersCount: preferencesClient.playersCount(),
            cards: cardLibrary.cards(),
            deck: cardLibrary.deck(),
            actionDelayMilliSeconds: preferencesClient.actionDelayMilliSeconds(),
            preferredFigure: preferencesClient.preferredFigure(),
            playModeSetup: preferencesClient.isSimulationEnabled() ? .allAuto : .oneManual
        )
    }
}

extension GameSessionFeature.State {
    struct Player: Equatable {
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

    struct HandCard: Equatable {
        let card: String
        let active: Bool
    }

    struct ChooseOne: Equatable {
        let resolvingAction: Card.ActionName
        let chooser: String
        let options: [String]
    }

    var players: [Player] {
        guard let game else {
            return []
        }

        return game.startOrder.map { playerId in
            let playerObj = game.players.get(playerId)
            let health = max(0, playerObj.health)
            let handCount = playerObj.hand.count
            let equipment = playerObj.inPlay
            let isTurn = playerId == game.turn
            let isEliminated = !game.playOrder.contains(playerId)
            let isTargeted = game.isTargeted(playerId)
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
        if let turn = game?.turn {
            "\(turn.uppercased())'s turn"
        } else {
            "-"
        }
    }

    var chooseOne: ChooseOne? {
        guard let game,
                let controlledPlayer = game.manuallyControlledPlayer(),
              let choice = game.pendingChoice(for: controlledPlayer) else {
            return  nil
        }

        return .init(
            resolvingAction: choice.action,
            chooser: choice.prompt.chooser,
            options: choice.prompt.options.map(\.label)
        )
    }

    var handCards: [HandCard] {
        guard let game,
              let controlledPlayer = game.manuallyControlledPlayer() else {
            return []
        }

        var playableCards: [String] = []
        if let playable = game.playable,
            playable.player == controlledPlayer {
            playableCards = playable.cards
        }
        let handCards = game.players.get(controlledPlayer).hand

        let hand = handCards.map { card in
            HandCard(
                card: card,
                active: playableCards.contains(card)
            )
        }

        let abilities = playableCards.compactMap { card in
            if !handCards.contains(card) {
                HandCard(
                    card: card,
                    active: true
                )
            } else {
                nil
            }
        }

        return hand + abilities
    }

    var topDiscard: String? {
        guard let game else {
            return nil
        }

        return game.discard.last
    }

    var deckCount: Int {
        guard let game else {
            return 0
        }

        return game.deck.count
    }

    var startOrder: [String] {
        guard let game else {
            return []
        }

        return game.startOrder
    }

    var actionDelaySeconds: TimeInterval {
        guard let game else {
            return 0
        }

        return game.actionDelaySeconds
    }

    var lastEvent: GameFeature.Action? {
        guard let game else {
            return nil
        }

        return game.lastEvent
    }

    var controlledPlayer: String? {
        guard let game else {
            return nil
        }

        return game.manuallyControlledPlayer()
    }
}
