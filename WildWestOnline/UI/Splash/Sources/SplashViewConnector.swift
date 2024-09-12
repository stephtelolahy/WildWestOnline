//
//  SplashViewConnector.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 12/09/2024.
//

import Redux
import AppCore
import NavigationCore

public extension SplashView {
    struct Connector: Redux.Connector {
        public init() {}

        public func deriveState(_ state: AppState) -> State? {
            .init()
        }

        public func embedAction(_ action: Action, _ state: AppState) -> Any {
            switch action {
            case .didAppear:
                RootNavigationAction.push(.home)
            }
        }
    }
}
