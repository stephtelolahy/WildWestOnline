//
//  Home.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

import AppCore
import Redux

public struct HomeState: Codable, Equatable {
}

public extension HomeState {
    static func from(globalState: AppState) -> Self? {
        .init()
    }
}
