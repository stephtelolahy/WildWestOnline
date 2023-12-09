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

public enum ScreenState: Codable, Equatable {
    case splash(SplashState)
    case home(HomeState)
    case game(GamePlayState)
    case settings
}

public extension AppState {
    static let reducer: Reducer<Self> = { state, action in
        var state = state

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

        // Reduce config
        if let action = action as? SettingsAction {
            state.config = SettingsState.reducer(.init(config: state.config), action).config
        }

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
                .settings
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

private extension ScreenState {
    static let reducer: Reducer<Self> = { state, action in
        switch state {
        case let .home(homeState):
                .home(HomeState.reducer(homeState, action))

        case let .game(gameState):
                .game(GamePlayState.reducer(gameState, action))

        default:
            state
        }
    }
}

extension GamePlayState {
    static func from(globalState: AppState) -> Self? {
        guard let lastScreen = globalState.screens.last,
              case let .game(gameState) = lastScreen else {
            return nil
        }

        return gameState
    }
}

extension HomeState {
    static func from(globalState: AppState) -> Self? {
        guard let lastScreen = globalState.screens.last,
              case let .home(homeState) = lastScreen else {
            return nil
        }

        return homeState
    }
}

extension SplashState {
    static func from(globalState: AppState) -> Self? {
        guard let lastScreen = globalState.screens.last,
              case let .splash(splashState) = lastScreen else {
            return nil
        }

        return splashState
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
