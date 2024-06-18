//
//  SaveSettingsMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 11/12/2023.
//

import Redux

public class SaveSettingsMiddleware: Middleware {
    private var service: SettingsService

    public init(service: SettingsService) {
        self.service = service
    }

    public func handle(_ action: SettingsAction, state: SettingsState) async -> SettingsAction? {
        switch action {
        case let .updatePlayersCount(value):
            service.playersCount = value

        case let .updateWaitDelayMilliseconds(delay):
            service.waitDelayMilliseconds = delay

        case .toggleSimulation:
            service.simulationEnabled = state.simulation

        case let .updatePreferredFigure(value):
            service.preferredFigure = value
        }

        return nil
    }
}
