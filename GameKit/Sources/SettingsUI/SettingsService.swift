//
//  SettingsService.swift
//  
//
//  Created by Hugues Telolahy on 13/12/2023.
//
// swiftlint:disable no_magic_numbers

import Utils

public protocol SettingsServiceProtocol {
    var playersCount: Int { get set }
    var simulationEnabled: Bool { get set }
}

public class SettingsService: SettingsServiceProtocol {
    public init() {}

    @UserDefaultsStored("settings.playersCount", defaultValue: 5)
    public var playersCount: Int

    @UserDefaultsStored("settings.simulationEnabled", defaultValue: false)
    public var simulationEnabled: Bool
}
