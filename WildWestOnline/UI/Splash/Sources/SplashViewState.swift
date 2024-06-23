// swiftlint:disable:this file_name
//
//  SplashViewState.swift
//
//
//  Created by Hugues Telolahy on 01/12/2023.
//
import AppCore

public extension SplashView {
    struct State: Equatable {
    }

    static let deriveState: (AppState) -> State? = { _ in
            .init()
    }
}
