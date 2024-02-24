//
//  SettingsState.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//
import GameCore
import Redux

public struct SettingsState: Codable, Equatable {
    public var playersCount: Int
    public var waitDelayMilliseconds: Int
    public var simulation: Bool
    public var inventory: Inventory?

    public init(
        playersCount: Int = 5,
        waitDelayMilliseconds: Int = 0,
        simulation: Bool = false,
        inventory: Inventory? = nil
    ) {
        self.inventory = inventory
        self.playersCount = playersCount
        self.waitDelayMilliseconds = waitDelayMilliseconds
        self.simulation = simulation
    }
}

public enum SettingsAction: Action, Codable, Equatable {
    case updatePlayersCount(Int)
    case updateWaitDelayMilliseconds(Int)
    case toggleSimulation
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

        case let .updateWaitDelayMilliseconds(value):
            state.waitDelayMilliseconds = value
        }

        return state
    }
}
