//
//  SettingsRepository.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//
// swiftlint:disable no_magic_numbers type_contents_order

import SettingsCore
import Serialization

public class SettingsRepository: SettingsService {
    public init() {}

    @UserDefaultsStored("settings.playersCount", defaultValue: 5)
    private var _playersCount: Int

    @UserDefaultsStored("settings.waitDelayMilliseconds", defaultValue: 500)
    private var _waitDelayMilliseconds: Int

    @UserDefaultsStored("settings.simulationEnabled", defaultValue: false)
    private var _simulationEnabled: Bool

    @OptionalUserDefaultsStored("settings.preferredFigure")
    private var _preferredFigure: String?

    public func playersCount() -> Int {
        _playersCount
    }

    public func setPlayersCount(_ value: Int) {
        _playersCount = value
    }

    public func waitDelayMilliseconds() -> Int {
        _waitDelayMilliseconds
    }

    public func setWaitDelayMilliseconds(_ value: Int) {
        _waitDelayMilliseconds = value
    }

    public func isSimulationEnabled() -> Bool {
        _simulationEnabled
    }

    public func setSimulationEnabled(_ value: Bool) {
        _simulationEnabled = value
    }

    public func preferredFigure() -> String? {
        _preferredFigure
    }

    public func setPreferredFigure(_ value: String?) {
        _preferredFigure = value
    }
}
