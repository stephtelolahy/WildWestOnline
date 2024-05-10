//
//  SettingsState.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//
import GameCore
import Redux

public struct SettingsState: Codable, Equatable {
    public let inventory: Inventory
    public var playersCount: Int
    public var waitDelayMilliseconds: Int
    public var simulation: Bool
    public var gamePlay: Int
    public var preferredFigure: String?
}

public enum SettingsAction: Action, Codable, Equatable {
    case updatePlayersCount(Int)
    case updateWaitDelayMilliseconds(Int)
    case toggleSimulation
    case updateGamePlay(Int)
    case updatePreferredFigure(String?)
}

public extension SettingsState {
    static let reducer: Reducer<Self> = { state, action in
        guard let action = action as? SettingsAction else {
            return state
        }

        var  state = state

        switch action {
        case let .updatePlayersCount(value):
            state.playersCount = value

        case let .updateWaitDelayMilliseconds(value):
            state.waitDelayMilliseconds = value

        case .toggleSimulation:
            state.simulation.toggle()

        case let .updateGamePlay(value):
            state.gamePlay = value

        case let .updatePreferredFigure(value):
            state.preferredFigure = value
        }

        return state
    }
}
