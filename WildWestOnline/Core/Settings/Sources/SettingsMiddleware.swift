// swiftlint:disable:this file_name
//
//  SettingsMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 11/12/2023.
//

import Redux

public extension Middlewares {
    static func saveSettings(with service: SettingsService) -> Middleware<SettingsState, SettingsAction> {
        { state, action in
            switch action {
            case let .updatePlayersCount(value):
                service.setPlayersCount(value)

            case let .updateWaitDelayMilliseconds(delay):
                service.setWaitDelayMilliseconds(delay)

            case .toggleSimulation:
                service.setSimulationEnabled(state.simulation)

            case let .updatePreferredFigure(value):
                service.setPreferredFigure(value)
            }

            return nil
        }
    }
}
