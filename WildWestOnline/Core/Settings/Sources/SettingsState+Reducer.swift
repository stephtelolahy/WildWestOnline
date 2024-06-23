//
//  SettingsState+Reducer.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 10/05/2024.
//
import Redux

public extension SettingsState {
    static let reducer: Reducer<Self> = { state, action in
        guard let action = action as? SettingsAction else {
            return state
        }

        var  state = state

        switch action {
        case let .updatePlayersCount(value):
            state.playersCount = value

        case let .updateWaitDelayMilliseconds(value):
            state.waitDelayMilliseconds = value

        case .toggleSimulation:
            state.simulation.toggle()

        case let .updatePreferredFigure(value):
            state.preferredFigure = value
        }

        return state
    }
}
