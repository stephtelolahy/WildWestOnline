//
//  SettingsCore.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import Redux

public struct SettingsState: Codable, Equatable, Sendable {
    public var playersCount: Int
    public var actionDelayMilliSeconds: Int
    public var simulation: Bool
    public var preferredFigure: String?
}

public enum SettingsAction: Action {
    case updatePlayersCount(Int)
    case updateActionDelayMilliSeconds(Int)
    case toggleSimulation
    case updatePreferredFigure(String?)
}

public struct SettingsDependencies {
    public var setPlayersCount: (Int) -> Void
    public var setActionDelayMilliSeconds: (Int) -> Void
    public var setSimulationEnabled: (Bool) -> Void
    public var setPreferredFigure: (String?) -> Void

    public init(
        setPlayersCount: @escaping (Int) -> Void,
        setActionDelayMilliSeconds: @escaping (Int) -> Void,
        setSimulationEnabled: @escaping (Bool) -> Void,
        setPreferredFigure: @escaping (String?) -> Void
    ) {
        self.setPlayersCount = setPlayersCount
        self.setActionDelayMilliSeconds = setActionDelayMilliSeconds
        self.setSimulationEnabled = setSimulationEnabled
        self.setPreferredFigure = setPreferredFigure
    }
}

public func settingsReducer(
    state: inout SettingsState,
    action: Action,
    dependencies: SettingsDependencies
) throws -> Effect {
    guard let action = action as? SettingsAction else {
        return .none
    }

    switch action {
    case .updatePlayersCount(let value):
        state.playersCount = value
        dependencies.setPlayersCount(value)

    case .updateActionDelayMilliSeconds(let value):
        state.actionDelayMilliSeconds = value
        dependencies.setActionDelayMilliSeconds(value)

    case .toggleSimulation:
        state.simulation.toggle()
        dependencies.setSimulationEnabled(state.simulation)

    case .updatePreferredFigure(let value):
        state.preferredFigure = value
        dependencies.setPreferredFigure(value)
    }

    return .none
}
