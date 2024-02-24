//
//  SplashViewState.swift
//
//
//  Created by Hugues Telolahy on 01/12/2023.
//
import AppCore
import Redux

extension SplashView {
    public struct State: Equatable {
    }
}

extension SplashView.State {
    public static func from(globalState: AppState) -> Self? {
        .init()
    }
}
