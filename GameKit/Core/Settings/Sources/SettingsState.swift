//
//  SettingsState.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//
import GameCore
import Redux

public struct SettingsState: Codable, Equatable {
    public var inventory: Inventory
    public var playersCount: Int
    public var waitDelayMilliseconds: Int
    public var simulation: Bool
    public var oldGamePlay: Bool

    public init(
        inventory: Inventory = .init(figures: [], cardSets: [:], cardRef: [:]),
        playersCount: Int = 5,
        waitDelayMilliseconds: Int = 0,
        simulation: Bool = false,
        oldGamePlay: Bool = false
    ) {
        self.inventory = inventory
        self.playersCount = playersCount
        self.waitDelayMilliseconds = waitDelayMilliseconds
        self.simulation = simulation
        self.oldGamePlay = oldGamePlay
    }
}

public enum SettingsAction: Action, Codable, Equatable {
    case updatePlayersCount(Int)
    case updateWaitDelayMilliseconds(Int)
    case toggleSimulation
    case toggleGamePlay
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

        case let .updateWaitDelayMilliseconds(value):
            state.waitDelayMilliseconds = value

        case .toggleSimulation:
            state.simulation.toggle()

        case .toggleGamePlay:
            state.oldGamePlay.toggle()
        }

        return state
    }
}
