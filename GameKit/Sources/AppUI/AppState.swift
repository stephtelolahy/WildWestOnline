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
    public let screens: [ScreenState]

    public init(screens: [ScreenState] = [.splash(.init())]) {
        self.screens = screens
    }
}

public extension AppState {
    static let reducer: Reducer<Self> = { state, action in
        var screens = state.screens

        // Update visible screens
        switch action {
        case let NavAction.showScreen(screen):
            screens.append(state.createStateForScreen(screen))

        case NavAction.dismiss:
            screens.removeLast()

        default:
            break
        }

        // Reduce each screen state
        screens = screens.map { ScreenState.reducer($0, action) }

        return .init(screens: screens)
    }
}

private extension AppState {
    func createStateForScreen(_ screen: Screen) -> ScreenState {
        switch screen {
        case .splash:
                .splash(.init())

        case .home:
                .home(.init())

        case .game:
                .game(.init(gameState: createGame()))

        case .settings:
                .settings(.init(config: createGameConfig()))
        }
    }

    func createGame() -> GameState {
        let playersCount = 5
        var game = Inventory.createGame(playersCount: playersCount)

        let sheriff = game.playOrder[0]
        game.playMode = game.startOrder.reduce(into: [:]) {
            $0[$1] = $1 == sheriff ? .manual : .auto
        }
        return game
    }

    func createGameConfig() -> GameConfig {
        let cachedPlayersCount = 7
        return .init(
            playersCount: cachedPlayersCount
        )
    }
}
