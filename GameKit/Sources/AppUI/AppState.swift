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
    public var user: String?
    public var screens: [Screen]
    public var config: GameConfig
    public var game: GameState?

    public init(
        user: String? = nil,
        screens: [Screen] = [.splash],
        config: GameConfig = Self.cachedGameConfig(),
        game: GameState? = nil
    ) {
        self.user = user
        self.screens = screens
        self.config = config
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
        if let gameState = GamePlayState.from(globalState: state) {
            state.game = GamePlayState.reducer(gameState, action).gameState
        }

        // Reduce config
        if let settingsState = SettingsState.from(globalState: state) {
            state.config = SettingsState.reducer(settingsState, action).config
        }

        return state
    }
}

public extension AppState {
    static func cachedGameConfig() -> GameConfig {
        let cachedPlayersCount = 7
        return .init(
            playersCount: cachedPlayersCount
        )
    }
}

private extension AppState {
    func createGame() -> GameState {
        var game = Inventory.createGame(playersCount: config.playersCount)

        let sheriff = game.playOrder[0]
        game.playMode = game.startOrder.reduce(into: [:]) {
            $0[$1] = $1 == sheriff ? .manual : .auto
        }
        return game
    }
}

extension GamePlayState {
    static func from(globalState: AppState) -> Self? {
        guard let lastScreen = globalState.screens.last,
              case .game = lastScreen,
                let game = globalState.game else {
            return nil
        }

        return .init(gameState: game)
    }
}

extension HomeState {
    static func from(globalState: AppState) -> Self? {
        guard let lastScreen = globalState.screens.last,
              case .home = lastScreen else {
            return nil
        }

        return .init()
    }
}

extension SplashState {
    static func from(globalState: AppState) -> Self? {
        guard let lastScreen = globalState.screens.last,
              case .splash = lastScreen else {
            return nil
        }

        return .init()
    }
}

extension SettingsState {
    static func from(globalState: AppState) -> Self? {
        guard let lastScreen = globalState.screens.last,
              case .settings = lastScreen else {
            return nil
        }

        return .init(config: globalState.config)
    }
}
