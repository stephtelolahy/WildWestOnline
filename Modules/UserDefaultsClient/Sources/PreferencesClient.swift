//
//  UserDefaultsClient.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2025.
//

public struct UserDefaultsClient {
    public var setPlayersCount: (Int) -> Void
    public var setActionDelayMilliSeconds: (Int) -> Void
    public var setSimulationEnabled: (Bool) -> Void
    public var setPreferredFigure: (String?) -> Void
    public var setMusicVolume: (Float) -> Void
    public var playersCount: () -> Int
    public var actionDelayMilliSeconds: () -> Int
    public var isSimulationEnabled: () -> Bool
    public var preferredFigure: () -> String?
    public var musicVolume: () -> Float

    public init(
        setPlayersCount: @escaping (Int) -> Void,
        setActionDelayMilliSeconds: @escaping (Int) -> Void,
        setSimulationEnabled: @escaping (Bool) -> Void,
        setPreferredFigure: @escaping (String?) -> Void,
        setMusicVolume: @escaping (Float) -> Void,
        playersCount: @escaping () -> Int,
        actionDelayMilliSeconds: @escaping () -> Int,
        isSimulationEnabled: @escaping () -> Bool,
        preferredFigure: @escaping () -> String?,
        musicVolume: @escaping () -> Float
    ) {
        self.setPlayersCount = setPlayersCount
        self.setActionDelayMilliSeconds = setActionDelayMilliSeconds
        self.setSimulationEnabled = setSimulationEnabled
        self.setPreferredFigure = setPreferredFigure
        self.setMusicVolume = setMusicVolume
        self.playersCount = playersCount
        self.actionDelayMilliSeconds = actionDelayMilliSeconds
        self.isSimulationEnabled = isSimulationEnabled
        self.preferredFigure = preferredFigure
        self.musicVolume = musicVolume
    }
}
