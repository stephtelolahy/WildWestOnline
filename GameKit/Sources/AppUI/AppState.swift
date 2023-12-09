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

public struct AppState: Codable, Equatable {
    public var screens: [ScreenState]
    public var config: GameConfig = Self.cachedGameConfig()

    public init(screens: [ScreenState] = [.splash(.init())]) {
        self.screens = screens
    }
}

public extension AppState {
    static let reducer: Reducer<Self> = { state, action in
        var state = state

        // Update global config
        #warning("duplicate config")
        if action is NavAction,
           case let .settings(settingsState) = state.screens.last {
            state.config = settingsState.config
        }

        // Update visible screens
        switch action {
        case let NavAction.showScreen(screen):
            state.screens.append(state.createStateForScreen(screen))

        case NavAction.dismiss:
            state.screens.removeLast()

        default:
            break
        }

        // Reduce each screen state
        state.screens = state.screens.map { ScreenState.reducer($0, action) }

        return state
    }
}

private extension AppState {
    static func cachedGameConfig() -> GameConfig {
        let cachedPlayersCount = 7
        return .init(
            playersCount: cachedPlayersCount
        )
    }

    func createStateForScreen(_ screen: Screen) -> ScreenState {
        switch screen {
        case .splash:
                .splash(.init())

        case .home:
                .home(.init())

        case .game:
                .game(.init(gameState: createGame()))

        case .settings:
                .settings(.init(config: config))
        }
    }

    func createGame() -> GameState {
        var game = Inventory.createGame(playersCount: config.playersCount)

        let sheriff = game.playOrder[0]
        game.playMode = game.startOrder.reduce(into: [:]) {
            $0[$1] = $1 == sheriff ? .manual : .auto
        }
        return game
    }
}
