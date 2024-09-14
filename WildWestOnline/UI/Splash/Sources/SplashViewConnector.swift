//
//  SplashViewConnector.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 12/09/2024.
//

import Redux
import AppCore
import NavigationCore

struct SplashViewConnector: Connector {
    func deriveState(_ state: AppState) -> SplashView.State? {
        .init()
    }

    func embedAction(_ action: SplashView.Action) -> Any {
        switch action {
        case .didAppear:
            NavigationStackAction<RootDestination>.push(.home)
        }
    }
}
