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

public extension AppState {
    static let reducer: Reducer<Self> = { state, action in
        var state = state
        state.navigation = try NavigationState.reducer(state.navigation, action)
        state.settings = try SettingsState.reducer(state.settings, action)
        state = try gameSetupReducer(state, action)
        state.game = try state.game.flatMap { try GameState.reducer($0, action) }
        return state
    }
}
