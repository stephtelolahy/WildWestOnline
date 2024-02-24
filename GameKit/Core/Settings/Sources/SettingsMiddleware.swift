//
//  SettingsMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 11/12/2023.
//

import Combine
import Redux

public protocol SettingsService {
    var playersCount: Int { get set }
    var simulationEnabled: Bool { get set }
    var waitDelayMilliseconds: Int { get set }
}

public class SettingsMiddleware: Middleware<SettingsState> {
    private var service: SettingsService

    public init(service: SettingsService) {
        self.service = service
        super.init()
    }

    override public func handle(action: Action, state: SettingsState) -> AnyPublisher<Action, Never>? {
        guard let action = action as? SettingsAction else {
            return nil
        }

        switch action {
        case let .updatePlayersCount(playersCount):
            service.playersCount = playersCount

        case .toggleSimulation:
            service.simulationEnabled = state.simulation

        case let .updateWaitDelayMilliseconds(delay):
            service.waitDelayMilliseconds = delay
        }

        return nil
    }
}
