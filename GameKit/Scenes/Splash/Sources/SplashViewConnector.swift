//
//  SplashViewConnector.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 10/05/2024.
//

import AppCore
import Redux

public extension Connectors {
    struct SplashViewConnector: Connector {
        public init() {}

        public func connect(state: AppState) -> SplashView.State? {
            .init()
        }
    }
}