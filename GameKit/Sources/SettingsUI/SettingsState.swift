//
//  SettingsState.swift
//
//
//  Created by Hugues Telolahy on 09/12/2023.
//
import Redux

public struct SettingsState: Codable, Equatable {
    public var playersCount: Int

    public init(playersCount: Int) {
        self.playersCount = playersCount
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
            state.playersCount = count
        }

        return state
    }
}
