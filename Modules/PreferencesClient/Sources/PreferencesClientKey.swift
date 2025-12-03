//
//  PreferencesClientKey.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//

import Redux

public extension Dependencies {
    var preferencesClient: PreferencesClient {
        get { self[PreferencesClientKey.self] }
        set { self[PreferencesClientKey.self] = newValue }
    }
}

private enum PreferencesClientKey: DependencyKey {
    nonisolated(unsafe) static let defaultValue: PreferencesClient = .noop
}

public extension PreferencesClient {
    static var noop: Self {
        .init(
            savePlayersCount: { _ in },
            saveActionDelayMilliSeconds: { _ in },
            saveSimulationEnabled: { _ in },
            savePreferredFigure: { _ in },
            saveMusicVolume: { _ in },
            playersCount: { 0 },
            actionDelayMilliSeconds: { 0 },
            isSimulationEnabled: { false },
            preferredFigure: { nil },
            musicVolume: { 0 }
        )
    }
}
