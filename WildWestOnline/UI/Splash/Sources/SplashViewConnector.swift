//
//  SplashViewConnector.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 12/09/2024.
//

import Redux
import AppCore
import NavigationCore

public struct SplashViewConnector: Connector {
    public init() {}

    public func deriveState(_ state: AppState) -> SplashView.State? {
        .init()
    }

    public func embedAction(_ action: SplashView.Action) -> Any {
        switch action {
        case .didAppear:
            NavigationAction<RootDestination>.push(.home)
        }
    }
}
