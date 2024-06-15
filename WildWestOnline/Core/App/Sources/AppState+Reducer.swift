//
//  AppState+Reducer.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 10/05/2024.
//
import GameCore
import Redux
import SettingsCore

public extension AppState {
    static let reducer: Reducer<Self, AppAction> = { state, action in
        var state = state

        switch action {
        case let .settings(settingsAction):
            state.settings = SettingsState.reducer(state.settings, settingsAction)

        case let .game(gameAction):
            state.game = state.game.flatMap { GameState.reducer($0, gameAction) }

        case let .navigate(screen):
            if case .splash = state.screens.last {
                state.screens = []
            }
            state.screens.append(screen)

        case .close:
            state.screens.removeLast()

        case .createGame:
            state.game = createGame(settings: state.settings)
            state.screens.append(.game)

        case .quitGame:
            state.game = nil
            state.screens.removeLast()
        }

        return state
    }
}

private extension AppState {
    static func createGame(settings: SettingsState) -> GameState {
        var game = Setup.createGame(
            playersCount: settings.playersCount,
            inventory: settings.inventory,
            preferredFigure: settings.preferredFigure
        )

        let manualPlayer: String? = settings.simulation ? nil : game.playOrder[0]
        game.playMode = game.startOrder.reduce(into: [:]) {
            $0[$1] = $1 == manualPlayer ? .manual : .auto
        }

        game.waitDelayMilliseconds = settings.waitDelayMilliseconds

        return game
    }
}
