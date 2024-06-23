// swiftlint:disable:this file_name
//
//  SettingsState+Middleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 11/12/2023.
//

import Redux

public extension Middlewares {
    static func saveSettings(with service: SettingsService) -> Middleware<SettingsState> {
        { state, action in
            switch action {
            case let SettingsAction.updatePlayersCount(value):
                service.setPlayersCount(value)

            case let SettingsAction.updateWaitDelayMilliseconds(delay):
                service.setWaitDelayMilliseconds(delay)

            case SettingsAction.toggleSimulation:
                service.setSimulationEnabled(state.simulation)

            case let SettingsAction.updatePreferredFigure(value):
                service.setPreferredFigure(value)

            default:
                break
            }

            return nil
        }
    }
}
