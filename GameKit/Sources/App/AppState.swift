//
//  AppState.swift
//
//
//  Created by Hugues Telolahy on 12/07/2023.
//
import Game
import GameUI
import HomeUI
import Inventory
import Redux
import Routing
import SettingsUI
import SplashUI

/// Global app state
/// Organize State Structure Based on Data Types, Not Components
/// https://redux.js.org/style-guide/#organize-state-structure-based-on-data-types-not-components
public struct AppState: Codable, Equatable {
    public var screens: [Screen]
    public var settings: SettingsState
    public var game: GameState?

    public init(
        screens: [Screen],
        settings: SettingsState,
        game: GameState? = nil
    ) {
        self.screens = screens
        self.settings = settings
        self.game = game
    }
}

public extension AppState {
    static let reducer: Reducer<Self> = { state, action in
        var state = state

        // Update visible screens
        switch action {
        case let NavAction.showScreen(screen, transition):
            switch transition {
            case .push:
                state.screens.append(screen)

            case .replace:
                state.screens = [screen]
            }

            // <create game>
            if case .game = screen {
                state.game = state.createGame()
            }
            // </create game>

        case NavAction.dismiss:
            // <delete game>
            if case .game = state.screens.last {
                state.game = nil
            }
            // </delete game>

            state.screens.removeLast()

        default:
            break
        }

        // Reduce game
        if let gameState = state.game {
            state.game = GameState.reducer(gameState, action)
        }

        // Reduce settings
        let settingsState = state.settings
        state.settings = SettingsState.reducer(settingsState, action)

        return state
    }
}

private extension AppState {
    func createGame() -> GameState {
        var game = Inventory.createGame(playersCount: settings.playersCount)

        var manualPlayer: String?
        if !settings.simulation {
            manualPlayer = game.playOrder[0]
        }

        game.playMode = game.startOrder.reduce(into: [:]) {
            $0[$1] = $1 == manualPlayer ? .manual : .auto
        }
        return game
    }
}

public extension GameState {
    static func from(globalState: AppState) -> Self? {
        globalState.game
    }
}

extension HomeState {
    static func from(globalState: AppState) -> Self? {
        .init()
    }
}

extension SplashState {
    static func from(globalState: AppState) -> Self? {
        .init()
    }
}

extension SettingsState {
    static func from(globalState: AppState) -> Self? {
        globalState.settings
    }
}
