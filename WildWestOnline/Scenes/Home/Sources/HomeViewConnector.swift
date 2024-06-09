//
//  HomeViewConnector.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 10/05/2024.
//

import AppCore
import Redux

public extension Connectors {
    struct HomeViewConnector: Connector {
        public init() {}

        public func deriveState(state: AppState) -> HomeView.State? {
            .init()
        }

        public func embedAction(action: HomeView.Action) -> AppAction {
            switch action {
            case .openSettings:
                .navigate(.settings)

            case .startGame:
                .navigate(.game)
            }
        }
    }
}
