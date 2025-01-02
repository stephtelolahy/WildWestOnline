//
//  SettingsReducer.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//
import Redux

public func settingsReducer(
    state: inout SettingsState,
    action: SettingsAction,
    dependencies: SettingsService
) throws -> Effect<SettingsAction> {
    switch action {
    case .updatePlayersCount(let value):
        state.playersCount = value
        dependencies.setPlayersCount(value)

    case .updateActionDelayMilliSeconds(let value):
        state.actionDelayMilliSeconds = value
        dependencies.setActionDelayMilliSeconds(value)

    case .toggleSimulation:
        state.simulation.toggle()
        dependencies.setSimulationEnabled(state.simulation)

    case .updatePreferredFigure(let value):
        state.preferredFigure = value
        dependencies.setPreferredFigure(value)
    }

    return .none
}
