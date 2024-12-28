//
//  SettingsService.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 07/05/2024.
//

public protocol SettingsService {
    func playersCount() -> Int
    func setPlayersCount(_ value: Int)

    func actionDelayMilliSeconds() -> Int
    func setActionDelayMilliSeconds(_ value: Int)

    func isSimulationEnabled() -> Bool
    func setSimulationEnabled(_ value: Bool)

    func preferredFigure() -> String?
    func setPreferredFigure(_ value: String?)
}
