//
//  SettingsFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import Redux

public enum SettingsFeature {
    public struct State: Equatable, Codable, Sendable {
        public var playersCount: Int
        public var actionDelayMilliSeconds: Int
        public var simulation: Bool
        public var preferredFigure: String?
    }

    public enum Action: ActionProtocol {
        case updatePlayersCount(Int)
        case updateActionDelayMilliSeconds(Int)
        case toggleSimulation
        case updatePreferredFigure(String?)
    }

    public struct Dependencies {
        public var savePlayersCount: (Int) -> Void
        public var saveActionDelayMilliSeconds: (Int) -> Void
        public var saveSimulationEnabled: (Bool) -> Void
        public var savePreferredFigure: (String?) -> Void

        public init(
            savePlayersCount: @escaping (Int) -> Void = { _ in },
            saveActionDelayMilliSeconds: @escaping (Int) -> Void = { _ in },
            saveSimulationEnabled: @escaping (Bool) -> Void = { _ in },
            savePreferredFigure: @escaping (String?) -> Void = { _ in }
        ) {
            self.savePlayersCount = savePlayersCount
            self.saveActionDelayMilliSeconds = saveActionDelayMilliSeconds
            self.saveSimulationEnabled = saveSimulationEnabled
            self.savePreferredFigure = savePreferredFigure
        }
    }

    public static func reduce(
        into state: inout State,
        action: ActionProtocol,
        dependencies: Dependencies
    ) throws -> Effect {
        guard let action = action as? Action else {
            return .none
        }

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
        }

        return .none
    }
}
