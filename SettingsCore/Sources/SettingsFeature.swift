//
//  SettingsFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import Redux
import SettingsClient

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
        dependencies: SettingsClient
    ) -> Effect<Action> {
        switch action {
        case .updatePlayersCount(let value):
            state.playersCount = value
            dependencies.savePlayersCount(value)

        case .updateActionDelayMilliSeconds(let value):
            state.actionDelayMilliSeconds = value
            dependencies.saveActionDelayMilliSeconds(value)

        case .toggleSimulation:
            state.simulation.toggle()
            dependencies.saveSimulationEnabled(state.simulation)

        case .updatePreferredFigure(let value):
            state.preferredFigure = value
            dependencies.savePreferredFigure(value)

        case .updateMusicVolume(let value):
            state.musicVolume = value
            dependencies.saveMusicVolume(value)
        }

        return .none
    }
}
