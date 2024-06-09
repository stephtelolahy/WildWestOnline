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
    static let reducer: ReducerV1<Self> = { state, action in
        var state = state
        state = screenReducer(state, action)
        state.settings = SettingsState.reducer(state.settings, action)
        state.game = state.game.flatMap { GameState.reducer($0, action) }
        return state
    }
}

private extension AppState {
    static let screenReducer: ReducerV1<Self> = { state, action in
        guard let action = action as? AppAction else {
            return state
        }

        var state = state
        switch action {
        case .navigate(let screen):
            if case .splash = state.screens.last {
                state.screens = []
            }
            state.screens.append(screen)

        case .close:
            state.screens.removeLast()

        case .startGame:
            state.game = createGame(settings: state.settings)
            state.screens.append(.game)

        case .exitGame:
            state.game = nil
            state.screens.removeLast()

        case .settings:
            // TODO: settings reducer
            break
        }
        return state
    }

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
