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
        case playButtonTapped
        case settingsButtonTapped
    }

    static let deriveState: (AppState) -> State? = { _ in
            .init()
    }

    static let embedAction: (Action, AppState) -> Redux.Action = { action, state in
        switch action {
        case .playButtonTapped:
            AppAction.startGame

        case .settingsButtonTapped:
            AppAction.navigate(.settings)
        }
    }
}
