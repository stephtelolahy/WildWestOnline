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
    public var savePlayersCount: (Int) -> Void
    public var saveActionDelayMilliSeconds: (Int) -> Void
    public var saveSimulationEnabled: (Bool) -> Void
    public var savePreferredFigure: (String?) -> Void

    public init(
        savePlayersCount: @escaping (Int) -> Void,
        saveActionDelayMilliSeconds: @escaping (Int) -> Void,
        saveSimulationEnabled: @escaping (Bool) -> Void,
        savePreferredFigure: @escaping (String?) -> Void
    ) {
        self.savePlayersCount = savePlayersCount
        self.saveActionDelayMilliSeconds = saveActionDelayMilliSeconds
        self.saveSimulationEnabled = saveSimulationEnabled
        self.savePreferredFigure = savePreferredFigure
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
