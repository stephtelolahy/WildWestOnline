//
//  Home.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

import Redux

public struct Home: ReducerProtocol {

    public struct State: Codable, Equatable {
    }

    public enum Action: Codable, Equatable {
        case onAppear
    }

    public func reduce(state: State, action: Action) -> State {
        state
    }
}
