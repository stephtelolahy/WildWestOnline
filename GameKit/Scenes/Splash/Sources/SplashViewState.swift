//
//  SplashViewState.swift
//
//
//  Created by Hugues Telolahy on 01/12/2023.
//
import AppCore
import Redux

extension SplashView {
    public struct State: Codable, Equatable {
    }
}

public extension SplashView.State {
    static func from(globalState: AppState) -> Self? {
        .init()
    }
}
