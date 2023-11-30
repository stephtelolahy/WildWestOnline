//
//  AppAction.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 30/11/2023.
//
import Redux

public enum AppAction: Action, Codable, Equatable {
    case showScreen(Screen)
    case dismiss
}

public enum Screen: Codable, Equatable {
    case splash
    case home
    case game
}
