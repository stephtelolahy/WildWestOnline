// swiftlint:disable:this file_name
//
//  HomeViewConnector.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//

import Redux
import AppCore
import NavigationCore

struct HomeViewConnector: Connector {
    func deriveState(_ state: AppState) -> HomeView.State? {
        .init()
    }

    func embedAction(_ action: HomeView.Action) -> Any {
        switch action {
        case .didTapPlayButton:
            GameSetupAction.start

        case .didTapSettingsButton:
            NavigationAction<RootDestination>.present(.settings)
        }
    }
}
