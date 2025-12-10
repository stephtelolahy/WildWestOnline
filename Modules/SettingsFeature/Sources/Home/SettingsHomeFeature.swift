//
//  SettingsHomeFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import Redux
import UserDefaultsClient
import AudioClient

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
        public var musicVolume: Float

        public init(
            playersCount: Int = 0,
            actionDelayMilliSeconds: Int = 0,
            simulation: Bool = false,
            preferredFigure: String? = nil,
            musicVolume: Float = 0
        ) {
            self.playersCount = playersCount
            self.actionDelayMilliSeconds = actionDelayMilliSeconds
            self.simulation = simulation
            self.preferredFigure = preferredFigure
            self.musicVolume = musicVolume
        }
    }

    public enum Action {
        // View
        case didAppear
        case didUpdatePlayersCount(Int)
        case didUpdateActionDelayMilliSeconds(Int)
        case didToggleSimulation
        case didUpdatePreferredFigure(String?)
        case didUpdateMusicVolume(Float)
        case didTapFigures
        case didTapCollectibles

        // Delegate
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
        case .didAppear:
            state.playersCount = dependencies.userDefaultsClient.playersCount()
            state.actionDelayMilliSeconds = dependencies.userDefaultsClient.actionDelayMilliSeconds()
            state.simulation = dependencies.userDefaultsClient.isSimulationEnabled()
            state.preferredFigure = dependencies.userDefaultsClient.preferredFigure()
            state.musicVolume = dependencies.userDefaultsClient.musicVolume()

        case .didUpdatePlayersCount(let value):
            state.playersCount = value
            dependencies.userDefaultsClient.setPlayersCount(value)

        case .didUpdateActionDelayMilliSeconds(let value):
            state.actionDelayMilliSeconds = value
            dependencies.userDefaultsClient.setActionDelayMilliSeconds(value)

        case .didToggleSimulation:
            state.simulation.toggle()
            dependencies.userDefaultsClient.setSimulationEnabled(state.simulation)

        case .didUpdatePreferredFigure(let value):
            state.preferredFigure = value
            dependencies.userDefaultsClient.setPreferredFigure(value)

        case .didUpdateMusicVolume(let value):
            state.musicVolume = value
            dependencies.userDefaultsClient.setMusicVolume(value)
            return .run {
                await dependencies.audioClient.setMusicVolume(value)
                return .none
            }

        case .didTapFigures:
            return .run {
                .delegate(.selectedFigures)
            }

        case .didTapCollectibles:
            return .run {
                .delegate(.selectedCollectibles)
            }

        case .delegate:
            break
        }

        return .none
    }
}
