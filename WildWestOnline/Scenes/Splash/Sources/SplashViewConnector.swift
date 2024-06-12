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

        public func deriveState(state: AppState) -> SplashView.State? {
            .init()
        }

        public func embedAction(action: SplashView.Action) -> AppAction {
            switch action {
            case .didAppear:
                return AppAction.navigate(.home)
            }
        }
    }
}
