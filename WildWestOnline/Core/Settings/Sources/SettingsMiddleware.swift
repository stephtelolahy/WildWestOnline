//
//  SettingsMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 11/12/2023.
//

import Redux

public extension Middlewares {
    static func saveSettings(service: SettingsService) -> Middleware<SettingsState> {
        { state, action in
            switch action {
            case SettingsAction.updatePlayersCount(let value):
                service.setPlayersCount(value)

            case SettingsAction.updateActionDelayMilliSeconds(let value):
                service.setActionDelayMilliSeconds(value)

            case SettingsAction.toggleSimulation:
                service.setSimulationEnabled(state.simulation)

            case SettingsAction.updatePreferredFigure(let value):
                service.setPreferredFigure(value)

            default:
                break
            }

            return nil
        }
    }
}
