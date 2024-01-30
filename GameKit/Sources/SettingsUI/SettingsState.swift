//
//  SettingsState.swift
//
//
//  Created by Hugues Telolahy on 09/12/2023.
//

import Redux

public struct SettingsState: Codable, Equatable {
    public var playersCount: Int
    public var waitDelayMilliseconds: Int
    public var simulation: Bool

    public init(
        playersCount: Int,
        waitDelayMilliseconds: Int,
        simulation: Bool
    ) {
        self.playersCount = playersCount
        self.waitDelayMilliseconds = waitDelayMilliseconds
        self.simulation = simulation
    }
}

public enum SettingsAction: Action, Codable, Equatable {
    case updatePlayersCount(Int)
    case toggleSimulation
    case close
}

public extension SettingsState {
    static let reducer: Reducer<Self> = { state, action in
        guard let action = action as? SettingsAction else {
            return state
        }

        var  state = state

        switch action {
        case let .updatePlayersCount(count):
            state.playersCount = count

        case .toggleSimulation:
            state.simulation.toggle()

        default:
            break
        }

        return state
    }
}
