//
//  Settings.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//
import Redux

public struct Settings: Codable, Equatable {
    public let inventory: Inventory
    public var playersCount: Int
    public var waitDelayMilliseconds: Int
    public var simulation: Bool

    public init(
        inventory: Inventory,
        playersCount: Int,
        waitDelayMilliseconds: Int,
        simulation: Bool
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

public extension Settings {
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
