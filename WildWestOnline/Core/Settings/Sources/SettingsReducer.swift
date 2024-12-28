//
//  SettingsReducer.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//
import Redux

public struct SettingsReducer {
    public init() {}

    public func reduce(_ state: SettingsState, _ action: Action) throws -> SettingsState {
        var state = state
        switch action {
        case SettingsAction.updatePlayersCount(let value):
            state.playersCount = value

        case SettingsAction.updateWaitDelaySeconds(let value):
            state.waitDelaySeconds = value

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
