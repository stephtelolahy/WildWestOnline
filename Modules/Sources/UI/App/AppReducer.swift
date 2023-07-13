//
//  AppReducer.swift
//  
//
//  Created by Hugues Telolahy on 12/07/2023.
//
import Redux
import Game
import Inventory

public struct AppState: Codable, Equatable {
    let screens: [ScreenState]

    public init(screens: [ScreenState]) {
        self.screens = screens
    }
}

public enum ScreenState: Codable, Equatable {
    case splash
    case home(Home.State)
    case game(GamePlay.State)
}

public enum AppAction: Codable, Equatable {
    case showScreen(Screen)
    case dismissScreen(Screen)
    case home(Home.Action)
    case game(GamePlay.Action)
}

public enum Screen: Codable, Equatable {
    case splash
    case home
    case game
}

public struct AppReducer: ReducerProtocol {

    public init() {}

    public func reduce(state: AppState, action: AppAction) -> AppState {
        var screens = state.screens

        // Update visible screens
        switch action {
        case .showScreen(.home):
            screens = [.home(.init())]

        case .dismissScreen(.game):
            screens.removeLast()

        case .showScreen(.game):
            let game = Inventory.createGame(playersCount: 5)
            screens.append(.game(game.toGamePlayState()))

        default:
            break
        }

        // Reduce each screen state
//        print("screens: \(screens)")
        screens = screens.map { reduceScreen($0, action) }

        return .init(screens: screens)
    }

    private func reduceScreen(_ state: ScreenState, _ action: AppAction) -> ScreenState {
        switch (state, action) {
        case let (.home(homeState), .home(homeAction)):
            return .home(Home().reduce(state: homeState, action: homeAction))

        case let (.game(gameState), .game(gameAction)):
            return .game(GamePlay().reduce(state: gameState, action: gameAction))

        default:
            return state
        }
    }
}

private extension GameState {
    func toGamePlayState() -> GamePlay.State {
        .init(players: playOrder.map { player($0) })
    }
}
