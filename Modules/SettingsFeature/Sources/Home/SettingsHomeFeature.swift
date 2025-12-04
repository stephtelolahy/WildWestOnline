//
//  SettingsHomeFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import Redux
import PreferencesClient

public enum SettingsHomeFeature {
    public struct State: Equatable, Sendable {
        let minPlayersCount = 2
        let maxPlayersCount = 7
        let speedOptions: [SpeedOption] = [
            .init(label: "Normal", value: 500),
            .init(label: "Fast", value: 0)
        ]

        struct SpeedOption: Equatable, Sendable {
            let label: String
            let value: Int
        }

        public var playersCount: Int
        public var actionDelayMilliSeconds: Int
        public var simulation: Bool
        public var preferredFigure: String?
        var musicVolume: Float
    }

    public enum Action {
        case onAppear
        case updatePlayersCount(Int)
        case updateActionDelayMilliSeconds(Int)
        case toggleSimulation
        case updatePreferredFigure(String?)
        case updateMusicVolume(Float)

        case delegate(Delegate)
        public enum Delegate {
            case selectedFigures
            case selectedCollectibles
        }
    }

    public static func reducer(
        state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.playersCount = dependencies.preferencesClient.playersCount()
            state.actionDelayMilliSeconds = dependencies.preferencesClient.actionDelayMilliSeconds()
            state.simulation = dependencies.preferencesClient.isSimulationEnabled()
            state.preferredFigure = dependencies.preferencesClient.preferredFigure()
            state.musicVolume = dependencies.preferencesClient.musicVolume()

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

        case .delegate:
            break
        }

        return .none
    }
}
