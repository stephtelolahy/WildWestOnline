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
    public var playersCount: () -> Int
    public var actionDelayMilliSeconds: () -> Int
    public var isSimulationEnabled: () -> Bool
    public var preferredFigure: () -> String?

    public init(
        savePlayersCount: @escaping (Int) -> Void = { _ in },
        saveActionDelayMilliSeconds: @escaping (Int) -> Void = { _ in },
        saveSimulationEnabled: @escaping (Bool) -> Void = { _ in },
        savePreferredFigure: @escaping (String?) -> Void = { _ in },
        playersCount: @escaping () -> Int = { 0 },
        actionDelayMilliSeconds: @escaping () -> Int = { 0 },
        isSimulationEnabled: @escaping () -> Bool = { false },
        preferredFigure: @escaping () -> String? = { nil }
    ) {
        self.savePlayersCount = savePlayersCount
        self.saveActionDelayMilliSeconds = saveActionDelayMilliSeconds
        self.saveSimulationEnabled = saveSimulationEnabled
        self.savePreferredFigure = savePreferredFigure
        self.playersCount = playersCount
        self.actionDelayMilliSeconds = actionDelayMilliSeconds
        self.isSimulationEnabled = isSimulationEnabled
        self.preferredFigure = preferredFigure
    }
}
