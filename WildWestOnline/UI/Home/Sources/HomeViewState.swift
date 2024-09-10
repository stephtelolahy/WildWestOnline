// swiftlint:disable:this file_name
//
//  HomeViewState.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//
import AppCore
import NavigationCore
import Redux

public extension HomeView {
    struct State: Equatable {
    }

    enum Action {
        case didTapPlayButton
        case didTapSettingsButton
    }

    struct Connector: Redux.Connector {
        public init() {}

        public func deriveState(_ state: AppState) -> State? {
            .init()
        }

        public func embedAction(_ action: Action, _ state: AppState) -> Any {
            switch action {
            case .didTapPlayButton:
                GameSetupAction.start

            case .didTapSettingsButton:
                RootNavigationAction.present(.settings)
            }
        }
    }
}
