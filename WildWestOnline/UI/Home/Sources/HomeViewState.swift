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
        case didTapPlayButton
        case didTapSettingsButton
    }

    static let deriveState: (AppState) -> State? = { _ in
            .init()
    }

    static let embedAction: (Action, AppState) -> Redux.Action = { action, _ in
        switch action {
        case .didTapPlayButton:
            AppAction.startGame

        case .didTapSettingsButton:
            AppAction.navigate(.settings)
        }
    }
}
