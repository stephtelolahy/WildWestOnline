// swiftlint:disable:this file_name
//
//  SplashViewState.swift
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
        case wiewAppeared
    }

    static let deriveState: (AppState) -> State? = { _ in
            .init()
    }

    static let embedAction: (Action, AppState) -> Redux.Action = { action, state in
        switch action {
        case .wiewAppeared:
            AppAction.navigate(.home)
        }
    }
}
