//
//  SettingsFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import Redux
import PreferencesClient

public enum SettingsFeature {
    public struct State: Equatable, Codable, Sendable {
        public var playersCount: Int
        public var actionDelayMilliSeconds: Int
        public var simulation: Bool
        public var preferredFigure: String?
        public var musicVolume: Float
    }

    public enum Action {
        case updatePlayersCount(Int)
        case updateActionDelayMilliSeconds(Int)
        case toggleSimulation
        case updatePreferredFigure(String?)
        case updateMusicVolume(Float)
    }

    public static func reducer(
        state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        switch action {
        case .updatePlayersCount(let value):
            state.playersCount = value
            dependencies.preferencesClient.savePlayersCount(value)

        case .updateActionDelayMilliSeconds(let value):
            state.actionDelayMilliSeconds = value
            dependencies.preferencesClient.saveActionDelayMilliSeconds(value)

        case .toggleSimulation:
            state.simulation.toggle()
            dependencies.preferencesClient.saveSimulationEnabled(state.simulation)

        case .updatePreferredFigure(let value):
            state.preferredFigure = value
            dependencies.preferencesClient.savePreferredFigure(value)

        case .updateMusicVolume(let value):
            state.musicVolume = value
            dependencies.preferencesClient.saveMusicVolume(value)
        }

        return .none
    }
}
