//
//  SplashState.swift
//  
//
//  Created by Hugues Telolahy on 01/12/2023.
//
import Redux

public struct SplashState: Codable, Equatable {
    public init() {}
}

public enum SplashAction: Action, Codable, Equatable {
    case finish
}
