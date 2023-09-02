//
//  AppState.swift
//
//
//  Created by Hugues Telolahy on 12/07/2023.
//
import Redux
import Game
import Inventory
import InitMacro

@Init
public struct AppState: Codable, Equatable {
    let screens: [ScreenState]

    public init() {
        screens = [.splash]
    }
}

public enum ScreenState: Codable, Equatable {
    case splash
    case home(HomeState)
    case game(GamePlayState)
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
            let game = Inventory.createGame(playersCount: 5)
            screens.append(.game(game.toGamePlayState()))

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

private extension GameState {
    func toGamePlayState() -> GamePlayState {
        .init(players: playOrder.map { player($0) })
    }
}
