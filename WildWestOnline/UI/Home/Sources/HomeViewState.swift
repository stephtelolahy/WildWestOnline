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

    struct Connector: Redux.Connector {
        public init() {}

        public func deriveState(_ state: App.State) -> State? {
            .init()
        }

        public func embedAction(_ action: Action) -> App.Action {
            switch action {
            case .didTapSettingsButton:
                    .navigate(.settings)

            case .didTapPlayButton:
                    .createGame
            }
        }
    }
}
