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

    enum Connector: Redux.Connector {
        public static func deriveState(_ state: AppState) -> State? {
            .init()
        }

        public static func embedAction(_ action: Action) -> AppAction {
            switch action {
            case .didAppear:
                return AppAction.navigate(.home)
            }
        }
    }
}
