//
//  GamePlayState.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//
import Redux
import Game

public struct GamePlayState: Codable, Equatable {
    var players: [Player]
    var controlled: String?
    var message: String = String()
}

public enum GamePlayAction: Action, Codable, Equatable {
    case load
}

extension GamePlayState {
    static let reducer: Reducer<Self> = { state, action in
        state
    }
}
