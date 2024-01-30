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

extension SettingsState {
    var speedOptions: [SpeedOption] {
        SpeedOption.all
    }

    var speedIndex: Int {
        SpeedOption.all.firstIndex { $0.value == waitDelayMilliseconds } ?? 0
    }
}

struct SpeedOption {
    let label: String
    let value: Int
}

private extension SpeedOption {
    static let defaultWaitDelay = 500

    static let all: [Self] = [
        .init(label: "Normal", value: defaultWaitDelay),
        .init(label: "Fast", value: 0)
    ]
}

public enum SettingsAction: Action, Codable, Equatable {
    case updatePlayersCount(Int)
    case updateWaitDelayMilliseconds(Int)
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
