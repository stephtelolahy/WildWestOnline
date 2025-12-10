//
//  UserDefaultsClientKey.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//

import Redux

public extension Dependencies {
    var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClientKey.self] }
        set { self[UserDefaultsClientKey.self] = newValue }
    }
}

private enum UserDefaultsClientKey: DependencyKey {
    nonisolated(unsafe) static let defaultValue: UserDefaultsClient = .noop
}

private extension UserDefaultsClient {
    static var noop: Self {
        .init(
            setPlayersCount: { _ in },
            setActionDelayMilliSeconds: { _ in },
            setSimulationEnabled: { _ in },
            setPreferredFigure: { _ in },
            setMusicVolume: { _ in },
            playersCount: { 0 },
            actionDelayMilliSeconds: { 0 },
            isSimulationEnabled: { false },
            preferredFigure: { nil },
            musicVolume: { 0 }
        )
    }
}
