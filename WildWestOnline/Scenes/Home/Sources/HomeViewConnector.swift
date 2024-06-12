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

        public func deriveState(_ state: AppState) -> HomeView.State? {
            .init()
        }

        public func embedAction(_ action: HomeView.Action) -> AppAction {
            switch action {
            case .didTapSettingsButton:
                .navigate(.settings)

            case .didTapPlayButton:
                .navigate(.game)
            }
        }
    }
}
