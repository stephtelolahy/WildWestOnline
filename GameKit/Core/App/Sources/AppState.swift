//
//  AppState.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//
import GameCore
import Redux
import SettingsCore

/// Global app state
/// Organize State Structure Based on Data Types, Not Components
/// https://redux.js.org/style-guide/#organize-state-structure-based-on-data-types-not-components
public struct AppState: Codable, Equatable {
    /// Screens stack
    public var screens: [Screen]

    /// App configuration
    public var settings: SettingsState

    /// Current game
    public var game: GameState?

    public init(screens: [Screen], settings: SettingsState, game: GameState? = nil) {
        self.screens = screens
        self.settings = settings
        self.game = game
    }
}

public enum Screen: Codable, Equatable {
    case splash
    case home
    case game
    case settings
}

public enum AppAction: Action {
    case navigate(Screen)
    case close
}

public extension AppState {
    static let reducer: Reducer<Self> = { state, action in
        var state = state
        state = screenReducer(state, action)
        state.settings = SettingsState.reducer(state.settings, action)
        state.game = state.game.flatMap { GameState.reducer($0, action) }
        return state
    }
}

private extension AppState {
    static let screenReducer: Reducer<Self> = { state, action in
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
            if case .game = screen {
                state.game = createGame(settings: state.settings)
            }

        case .close:
            if case .game = state.screens.last {
                state.game = nil
            }
            state.screens.removeLast()
        }
        return state
    }

    static func createGame(settings: SettingsState) -> GameState {
        guard let inventory = settings.inventory else {
            fatalError("Missing inventory")
        }

        var game = Setup.createGame(playersCount: settings.playersCount, inventory: inventory)

        let manualPlayer: String? = settings.simulation ? nil : game.playOrder[0]
        game.playMode = game.startOrder.reduce(into: [:]) {
            $0[$1] = $1 == manualPlayer ? .manual : .auto
        }

        game.waitDelayMilliseconds = settings.waitDelayMilliseconds

        return game
    }
}