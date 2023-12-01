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
import ScreenSplash

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
