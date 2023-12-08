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
import GameUI
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
        case NavAction.showScreen(.home):
            screens = [.home(.init())]

        case NavAction.showScreen(.game):
            let playersCount = 5
            var game = Inventory.createGame(playersCount: playersCount)

            let sheriff = game.playOrder[0]
            game.playMode = game.startOrder.reduce(into: [:]) {
                $0[$1] = $1 == sheriff ? .manual : .auto
            }

            let gamePlayState = GamePlayState(gameState: game)
            screens.append(.game(gamePlayState))

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
