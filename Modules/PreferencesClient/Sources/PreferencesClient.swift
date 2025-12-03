//
//  PreferencesClient.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2025.
//

public struct PreferencesClient {
    public var savePlayersCount: (Int) -> Void
    public var saveActionDelayMilliSeconds: (Int) -> Void
    public var saveSimulationEnabled: (Bool) -> Void
    public var savePreferredFigure: (String?) -> Void
    public var saveMusicVolume: (Float) -> Void
    public var playersCount: () -> Int
    public var actionDelayMilliSeconds: () -> Int
    public var isSimulationEnabled: () -> Bool
    public var preferredFigure: () -> String?
    public var musicVolume: () -> Float

    public init(
        savePlayersCount: @escaping (Int) -> Void,
        saveActionDelayMilliSeconds: @escaping (Int) -> Void,
        saveSimulationEnabled: @escaping (Bool) -> Void,
        savePreferredFigure: @escaping (String?) -> Void,
        saveMusicVolume: @escaping (Float) -> Void,
        playersCount: @escaping () -> Int,
        actionDelayMilliSeconds: @escaping () -> Int,
        isSimulationEnabled: @escaping () -> Bool,
        preferredFigure: @escaping () -> String?,
        musicVolume: @escaping () -> Float
    ) {
        self.savePlayersCount = savePlayersCount
        self.saveActionDelayMilliSeconds = saveActionDelayMilliSeconds
        self.saveSimulationEnabled = saveSimulationEnabled
        self.savePreferredFigure = savePreferredFigure
        self.saveMusicVolume = saveMusicVolume
        self.playersCount = playersCount
        self.actionDelayMilliSeconds = actionDelayMilliSeconds
        self.isSimulationEnabled = isSimulationEnabled
        self.preferredFigure = preferredFigure
        self.musicVolume = musicVolume
    }
}
