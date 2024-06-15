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

    struct Connector: Redux.Connector {
        public init() {}

        public func deriveState(_ state: App.State) -> State? {
            .init()
        }

        public func embedAction(_ action: Action) -> App.Action {
            switch action {
            case .didAppear:
                return App.Action.navigate(.home)
            }
        }
    }
}
