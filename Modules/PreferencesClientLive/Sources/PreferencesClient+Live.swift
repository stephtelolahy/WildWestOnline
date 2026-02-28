//
//  PreferencesClient+Live.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//
// swiftlint:disable no_magic_numbers

import PreferencesClient
import SwiftUI

public extension PreferencesClient {
    static func live() -> Self {
        let service = StorageService()
        return .init(
            setPlayersCount: { service.playersCount = $0 },
            setActionDelayMilliSeconds: { service.actionDelayMilliSeconds = $0 },
            setSimulationEnabled: { service.simulationEnabled = $0 },
            setPreferredFigure: { service.preferredFigure = $0 },
            setMusicVolume: { service.musicVolume = Double($0) },
            playersCount: { service.playersCount },
            actionDelayMilliSeconds: { service.actionDelayMilliSeconds },
            isSimulationEnabled: { service.simulationEnabled },
            preferredFigure: { service.preferredFigure },
            musicVolume: { Float(service.musicVolume) }
        )
    }

    private class StorageService {
        init() {}

        @AppStorage("settings.playersCount")
        var playersCount: Int = 5

        @AppStorage("settings.actionDelayMilliSeconds")
        var actionDelayMilliSeconds: Int = 500

        @AppStorage("settings.simulationEnabled")
        var simulationEnabled: Bool = false

        @AppStorage("settings.preferredFigure")
        var preferredFigure: String?

        @AppStorage("settings.musicVolume")
        var musicVolume: Double = 1.0
    }
}
