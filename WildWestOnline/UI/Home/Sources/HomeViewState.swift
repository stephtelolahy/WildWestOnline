// swiftlint:disable:this file_name
//
//  HomeViewState.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//
import AppCore
import Redux

public extension HomeView {
    struct State: Equatable {
    }

    enum Action {
        case didTapSettingsButton
        case didTapPlayButton
    }

    enum Connector: Redux.Connector {
        public static func deriveState(_ state: AppState) -> State? {
            .init()
        }

        public static func embedAction(_ action: Action) -> AppAction {
            switch action {
            case .didTapSettingsButton:
                    .navigate(.settings)

            case .didTapPlayButton:
                    .createGame
            }
        }
    }
}
