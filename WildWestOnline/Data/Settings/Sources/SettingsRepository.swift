//
//  SettingsRepository.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//
// swiftlint:disable no_magic_numbers type_contents_order

import Serialization
import SettingsCore

public class SettingsRepository {
    public init() {}

    @UserDefaultsStored("settings.playersCount", defaultValue: 5)
    private var _playersCount: Int

    @UserDefaultsStored("settings.actionDelayMilliSeconds", defaultValue: 500)
    private var _actionDelayMilliSeconds: Int

    @UserDefaultsStored("settings.simulationEnabled", defaultValue: false)
    private var _simulationEnabled: Bool

    @OptionalUserDefaultsStored("settings.preferredFigure")
    private var _preferredFigure: String?

    public func playersCount() -> Int {
        _playersCount
    }

    public func savePlayersCount(_ value: Int) {
        _playersCount = value
    }

    public func actionDelayMilliSeconds() -> Int {
        _actionDelayMilliSeconds
    }

    public func saveActionDelayMilliSeconds(_ value: Int) {
        _actionDelayMilliSeconds = value
    }

    public func isSimulationEnabled() -> Bool {
        _simulationEnabled
    }

    public func saveSimulationEnabled(_ value: Bool) {
        _simulationEnabled = value
    }

    public func preferredFigure() -> String? {
        _preferredFigure
    }

    public func savePreferredFigure(_ value: String?) {
        _preferredFigure = value
    }
}
