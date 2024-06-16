// swiftlint:disable:this file_name
//
//  SplashViewModel.swift
//
//
//  Created by Hugues Telolahy on 01/12/2023.
//
import AppCore
import Redux

public extension SplashView {
    struct State: Equatable {
    }

    enum Action {
        case didAppear
    }

    static let deriveState: (AppState) -> State? = { _ in
        .init()
    }

    static let embedAction: (Action) -> AppAction = { action in
        switch action {
        case .didAppear:
            return AppAction.navigate(.home)
        }
    }
}
