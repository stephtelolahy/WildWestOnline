//
//  ScreenState.swift
//  
//
//  Created by Hugues Telolahy on 02/09/2023.
//
import Redux
import ScreenGame
import ScreenHome

public enum ScreenState: Codable, Equatable {
    case splash
    case home(HomeState)
    case game(GamePlayState)
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
