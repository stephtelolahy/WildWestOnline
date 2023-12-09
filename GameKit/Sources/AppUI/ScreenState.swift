//
//  ScreenState.swift
//  
//
//  Created by Hugues Telolahy on 09/12/2023.
//
import GameUI
import HomeUI
import Redux
import SettingsUI
import SplashUI

public enum ScreenState: Codable, Equatable {
    case splash(SplashState)
    case home(HomeState)
    case game(GamePlayState)
    case settings(SettingsState)
}

extension ScreenState {
    static let reducer: Reducer<Self> = { state, action in
        switch state {
        case let .home(homeState):
                .home(HomeState.reducer(homeState, action))

        case let .game(gameState):
                .game(GamePlayState.reducer(gameState, action))

        case let .settings(settingsState):
                .settings(SettingsState.reducer(settingsState, action))

        default:
            state
        }
    }
}
