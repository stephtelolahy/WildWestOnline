//
//  SettingsClient+Live.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//
// swiftlint:disable no_magic_numbers

import Serialization
import SettingsClient

public extension SettingsClient {
    static func live() -> Self {
        let service = StorageService()
        return .init(
            savePlayersCount: { service.playersCount = $0 },
            saveActionDelayMilliSeconds: { service.actionDelayMilliSeconds = $0 },
            saveSimulationEnabled: { service.simulationEnabled = $0 },
            savePreferredFigure: { service.preferredFigure = $0 },
            saveMusicVolume: { service.musicVolume = $0 },
            playersCount: { service.playersCount },
            actionDelayMilliSeconds: { service.actionDelayMilliSeconds },
            isSimulationEnabled: { service.simulationEnabled },
            preferredFigure: { service.preferredFigure },
            musicVolume: { service.musicVolume }
        )
    }

    private class StorageService {
        init() {}

        @UserDefaultsStored("settings.playersCount", defaultValue: 5)
        var playersCount: Int

        @UserDefaultsStored("settings.actionDelayMilliSeconds", defaultValue: 500)
        var actionDelayMilliSeconds: Int

        @UserDefaultsStored("settings.simulationEnabled", defaultValue: false)
        var simulationEnabled: Bool

        @OptionalUserDefaultsStored("settings.preferredFigure")
        var preferredFigure: String?

        @UserDefaultsStored("settings.musicVolume", defaultValue: 1.0)
        var musicVolume: Float
    }
}
