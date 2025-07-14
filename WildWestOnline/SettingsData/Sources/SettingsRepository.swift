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
    public private(set) var playersCount: Int

    @UserDefaultsStored("settings.actionDelayMilliSeconds", defaultValue: 500)
    public private(set) var actionDelayMilliSeconds: Int

    @UserDefaultsStored("settings.simulationEnabled", defaultValue: false)
    public private(set) var simulationEnabled: Bool

    @OptionalUserDefaultsStored("settings.preferredFigure")
    public private(set) var preferredFigure: String?

    public func savePlayersCount(_ value: Int) {
        _playersCount.wrappedValue = value
    }

    public func saveActionDelayMilliSeconds(_ value: Int) {
        _actionDelayMilliSeconds.wrappedValue = value
    }

    public func saveSimulationEnabled(_ value: Bool) {
        _simulationEnabled.wrappedValue = value
    }

    public func savePreferredFigure(_ value: String?) {
        _preferredFigure.wrappedValue = value
    }
}
