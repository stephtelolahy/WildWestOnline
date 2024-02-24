//
//  HomeViewState.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//

import AppCore
import Redux

extension HomeView {
    public struct State: Codable, Equatable {
    }
}

extension HomeView.State {
    public static func from(globalState: AppState) -> Self? {
        .init()
    }
}
