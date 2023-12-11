//
//  SettingsCacheMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 11/12/2023.
//
// swiftlint:disable modifier_order
import Combine
import Foundation
import Redux
import SettingsUI

public class SettingsCacheMiddleware: Middleware<SettingsState> {
    public override init() {
        super.init()
    }

    override public func handle(action: Action, state: SettingsState) -> AnyPublisher<Action, Never>? {
        guard let action = action as? SettingsAction else {
            return nil
        }

        switch action {
        case let .updatePlayersCount(playersCount):
            UserDefaults.standard.setValue(playersCount, forKey: "settings.playersCount")

        case .toggleSimulation:
            UserDefaults.standard.setValue(state.simulation, forKey: "settings.simulation")
        }

        return nil
    }
}
