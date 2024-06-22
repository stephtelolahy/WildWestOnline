//
//  SaveSettingsMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 11/12/2023.
//

import Redux

public struct SaveSettingsMiddleware: Middleware {
    private let service: SettingsService

    public init(service: SettingsService) {
        self.service = service
    }

    public func effect(on action: Action, state: SettingsState) async -> Action? {
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
