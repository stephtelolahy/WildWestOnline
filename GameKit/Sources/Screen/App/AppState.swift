//
//  AppState.swift
//
//
//  Created by Hugues Telolahy on 12/07/2023.
//
import Game
import InitMacro
import Inventory
import Redux

@Init
public struct AppState: Codable, Equatable {
    let screens: [ScreenState]

    public init() {
        screens = [.splash]
    }
}

public enum AppAction: Action, Codable, Equatable {
    case showScreen(Screen)
    case dismissScreen(Screen)
}

public enum Screen: Codable, Equatable {
    case splash
    case home
    case game
}

public extension AppState {
    static let reducer: Reducer<Self> = { state, action in
        var screens = state.screens

        // Update visible screens
        switch action {
        case AppAction.showScreen(.home):
            screens = [.home(.init())]

        case AppAction.dismissScreen(.game):
            screens.removeLast()

        case AppAction.showScreen(.game):
            let playersCount = 5
            let game = Inventory.createGame(playersCount: playersCount)
            let gamePlayState = GamePlayState(players: game.playOrder.map { game.player($0) })
            screens.append(.game(gamePlayState))

        default:
            break
        }

        // Reduce each screen state
        screens = screens.map { ScreenState.reducer($0, action) }

        return .init(screens: screens)
    }
}
