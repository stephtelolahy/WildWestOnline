//
//  SaveSettingsMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 11/12/2023.
//

import Redux

public class SaveSettingsMiddleware: Middleware<SettingsState> {
    private var service: SettingsService

    public init(service: SettingsService) {
        self.service = service
        super.init()
    }

    override public func effect(on action: Action, state: SettingsState) async -> Action? {
        guard let action = action as? SettingsAction else {
            return nil
        }

        switch action {
        case let .updatePlayersCount(value):
            service.playersCount = value

        case let .updateWaitDelayMilliseconds(delay):
            service.waitDelayMilliseconds = delay

        case .toggleSimulation:
            service.simulationEnabled = state.simulation

        case let .updateGamePlay(value):
            service.gamePlay = value

        case let .updatePreferredFigure(value):
            service.preferredFigure = value
        }

        return nil
    }
}
