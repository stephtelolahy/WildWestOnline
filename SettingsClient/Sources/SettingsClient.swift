//
//  SettingsClient.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2025.
//

public struct SettingsClient {
    public var savePlayersCount: (Int) -> Void
    public var saveActionDelayMilliSeconds: (Int) -> Void
    public var saveSimulationEnabled: (Bool) -> Void
    public var savePreferredFigure: (String?) -> Void

    public init(
        savePlayersCount: @escaping (Int) -> Void = { _ in },
        saveActionDelayMilliSeconds: @escaping (Int) -> Void = { _ in },
        saveSimulationEnabled: @escaping (Bool) -> Void = { _ in },
        savePreferredFigure: @escaping (String?) -> Void = { _ in }
    ) {
        self.savePlayersCount = savePlayersCount
        self.saveActionDelayMilliSeconds = saveActionDelayMilliSeconds
        self.saveSimulationEnabled = saveSimulationEnabled
        self.savePreferredFigure = savePreferredFigure
    }
}
