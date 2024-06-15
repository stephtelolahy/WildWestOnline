//
//  SettingsRepository.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//
// swiftlint:disable no_magic_numbers

import SettingsCore
import Utils

public class SettingsRepository: SettingsService {
    @UserDefaultsStored("settings.playersCount", defaultValue: 5)
    public var playersCount: Int

    @UserDefaultsStored("settings.waitDelayMilliseconds", defaultValue: 500)
    public var waitDelayMilliseconds: Int

    @UserDefaultsStored("settings.simulationEnabled", defaultValue: false)
    public var simulationEnabled: Bool

    @OptionalUserDefaultsStored("settings.preferredFigure")
    public var preferredFigure: String?

    public init() {}
}
