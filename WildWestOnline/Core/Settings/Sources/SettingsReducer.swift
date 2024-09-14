// swiftlint:disable:this file_name
//
//  SettingsReducer.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//
import Redux

public extension SettingsState {
    static let reducer: Reducer<Self> = { state, action in
        var state = state
        switch action {
        case SettingsAction.updatePlayersCount(let value):
            state.playersCount = value

        case SettingsAction.updateWaitDelayMilliseconds(let value):
            state.waitDelayMilliseconds = value

        case SettingsAction.toggleSimulation:
            state.simulation.toggle()

        case SettingsAction.updatePreferredFigure(let value):
            state.preferredFigure = value

        default:
            break
        }

        return state
    }
}
