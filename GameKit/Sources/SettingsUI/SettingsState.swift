//
//  SettingsState.swift
//  
//
//  Created by Hugues Telolahy on 09/12/2023.
//
import Inventory
import Redux

public struct SettingsState: Codable, Equatable {
    public var config: GameConfig

    public init(config: GameConfig) {
        self.config = config
    }
}

// MARK: - Derived state
extension SettingsState {
    var playersCount: Int {
        config.playersCount
    }
}

public enum SettingsAction: Action, Codable, Equatable {
    case updatePlayersCount(Int)
}

public extension SettingsState {
    static let reducer: Reducer<Self> = { state, action in
        guard let action = action as? SettingsAction else {
            return state
        }

        var  state = state

        switch action {
        case let .updatePlayersCount(count):
            state.config.playersCount = count
        }

        return state
    }
}
