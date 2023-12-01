//
//  AppState.swift
//
//
//  Created by Hugues Telolahy on 12/07/2023.
//
import Game
import Inventory
import Redux
import Routing
import ScreenGame
import ScreenHome
import ScreenSplash

public struct AppState: Codable, Equatable {
    public let screens: [ScreenState]

    public init(screens: [ScreenState] = [.splash(.init())]) {
        self.screens = screens
    }
}

public enum ScreenState: Codable, Equatable {
    case splash(SplashState)
    case home(HomeState)
    case game(GamePlayState)
}

public extension AppState {
    static let reducer: Reducer<Self> = { state, action in
        var screens = state.screens

        // Update visible screens
        switch action {
        case AppAction.showScreen(.home):
            screens = [.home(.init())]

        case AppAction.dismiss:
            screens.removeLast()

        case AppAction.showScreen(.game):
            let playersCount = 5
            let game = Inventory.createGame(playersCount: playersCount)
            let gamePlayState = GamePlayState(gameState: game)
            screens.append(.game(gamePlayState))

        default:
            break
        }

        // Reduce each screen state
        screens = screens.map { ScreenState.reducer($0, action) }

        return .init(screens: screens)
    }
}

extension ScreenState {
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
