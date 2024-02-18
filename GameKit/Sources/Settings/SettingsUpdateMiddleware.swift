//
//  SettingsUpdateMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 11/12/2023.
//

import Combine
import Foundation
import Redux

public class SettingsUpdateMiddleware: Middleware<SettingsState> {
    private var cacheService: SettingsServiceProtocol

    public init(cacheService: SettingsServiceProtocol) {
        self.cacheService = cacheService
        super.init()
    }

    override public func handle(action: Action, state: SettingsState) -> AnyPublisher<Action, Never>? {
        guard let action = action as? SettingsAction else {
            return nil
        }

        switch action {
        case let .updatePlayersCount(playersCount):
            cacheService.playersCount = playersCount

        case .toggleSimulation:
            cacheService.simulationEnabled = state.simulation

        case let .updateWaitDelayMilliseconds(delay):
            cacheService.waitDelayMilliseconds = delay

        default:
            break
        }

        return nil
    }
}
