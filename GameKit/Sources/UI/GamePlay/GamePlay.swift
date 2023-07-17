//
//  GamePlay.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//
import Redux
import Game

public struct GamePlay: ReducerProtocol {

    public struct State: Codable, Equatable {
        var players: [Player]
        var controlled: String?
        var message: String = String()
    }

    public enum Action: Codable, Equatable {
        case onAppear
    }

    public func reduce(state: State, action: Action) -> State {
        state
    }
}
