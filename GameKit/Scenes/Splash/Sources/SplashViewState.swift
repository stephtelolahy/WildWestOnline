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
}

public extension SplashView.State {
    static func from(globalState: AppState) -> Self? {
        .init()
    }
}
