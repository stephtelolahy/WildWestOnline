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
        public func connect(state: AppState) -> HomeView.State {
            .init()
        }
    }
}
