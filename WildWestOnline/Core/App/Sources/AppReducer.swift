//
//  AppReducer.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//
import Redux
import NavigationCore
import SettingsCore
import GameCore

public struct AppReducer {
    public init() {}

    public func reduce(_ state: AppState, _ action: Action) throws -> AppState {
        var state = state
        state.navigation = try NavigationReducer().reduce(state.navigation, action)
        state.settings = try SettingsReducer().reduce(state.settings, action)
        state.game = try state.game.flatMap { try GameReducer().reduce($0, action) }
        state = try GameSetupReducer().reduce(state, action)
        return state
    }
}
