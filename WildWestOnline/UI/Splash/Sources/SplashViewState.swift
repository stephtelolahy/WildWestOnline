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
        case didAppear
    }

    static let deriveState: (AppState) -> State? = { _ in
            .init()
    }

    static let embedAction: (Action, AppState) -> Any = { action, _ in
        switch action {
        case .didAppear:
            AppAction.navigate(.home)
        }
    }
}
