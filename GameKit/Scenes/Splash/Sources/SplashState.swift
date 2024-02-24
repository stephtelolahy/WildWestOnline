//
//  SplashState.swift
//  
//
//  Created by Hugues Telolahy on 01/12/2023.
//
import AppCore
import Redux

public struct SplashState: Codable, Equatable {
}

public extension SplashState {
    static func from(globalState: AppState) -> Self? {
        .init()
    }
}
