//
//  PreferencesClientKey.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//

import Redux

public extension Dependencies {
    var userDefaultsClient: PreferencesClient {
        get { self[PreferencesClientKey.self] }
        set { self[PreferencesClientKey.self] = newValue }
    }
}

private enum PreferencesClientKey: DependencyKey {
    nonisolated(unsafe) static let defaultValue: PreferencesClient = .noop
}

private extension PreferencesClient {
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
