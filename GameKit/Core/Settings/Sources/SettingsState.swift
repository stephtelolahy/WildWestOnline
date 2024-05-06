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
    public var gamePlay: Int
    public var preferredFigure: Int

    public init(
        inventory: Inventory = .init(figures: [], cardSets: [:], cardRef: [:]),
        playersCount: Int = 5,
        waitDelayMilliseconds: Int = 0,
        simulation: Bool = false,
        gamePlay: Int = 0,
        preferredFigure: Int = 0
    ) {
        self.inventory = inventory
        self.playersCount = playersCount
        self.waitDelayMilliseconds = waitDelayMilliseconds
        self.simulation = simulation
        self.gamePlay = gamePlay
        self.preferredFigure = preferredFigure
    }
}

public enum SettingsAction: Action, Codable, Equatable {
    case updatePlayersCount(Int)
    case updateWaitDelayMilliseconds(Int)
    case toggleSimulation
    case updateGamePlay(Int)
    case updatePreferredFigure(Int)
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

        case let .updateGamePlay(value):
            state.gamePlay = value

        case let .updatePreferredFigure(value):
            state.preferredFigure = value
        }

        return state
    }
}
