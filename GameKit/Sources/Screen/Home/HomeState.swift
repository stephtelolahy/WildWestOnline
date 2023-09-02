//
//  Home.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

import Redux

public struct HomeState: Codable, Equatable {
}

public enum HomeAction: Action, Codable, Equatable {
    case load
}

public extension HomeState {
    static let reducer: Reducer<Self> = { state, _ in
        state
    }
}
