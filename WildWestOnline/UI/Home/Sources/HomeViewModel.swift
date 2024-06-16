// swiftlint:disable:this file_name
//
//  HomeViewModel.swift
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

    static let deriveState: (AppState) -> State?  = { _ in
        .init()
    }

    static let embedAction: (Action) -> AppAction = { action in
        switch action {
        case .didTapSettingsButton:
                .navigate(.settings)

        case .didTapPlayButton:
                .createGame
        }
    }
}
