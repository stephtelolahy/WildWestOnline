//
//  SettingsState.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//
import Redux

public struct SettingsState: Codable, Equatable {
    public var playersCount: Int
    public var waitDelayMilliseconds: Int
    public var simulation: Bool
    public var preferredFigure: String?
}

public extension SettingsState {
    static let reducer: Reducer<Self> = { state, action in
        switch action {
        case SettingsAction.updatePlayersCount:
            try updatePlayersCountReducer(state, action)

        case SettingsAction.updateWaitDelayMilliseconds:
            try updateWaitDelayMillisecondsReducer(state, action)

        case SettingsAction.toggleSimulation:
            try toggleSimulationReducer(state, action)

        case SettingsAction.updatePreferredFigure:
            try updatePreferredFigureReducer(state, action)

        default:
            state
        }
    }
}

private extension SettingsState {
    static let updatePlayersCountReducer: Reducer<Self> = { state, action in
        guard case let SettingsAction.updatePlayersCount(value) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.playersCount = value
        return state
    }

    static let updateWaitDelayMillisecondsReducer: Reducer<Self> = { state, action in
        guard case let SettingsAction.updateWaitDelayMilliseconds(value) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.waitDelayMilliseconds = value
        return state
    }

    static let toggleSimulationReducer: Reducer<Self> = { state, action in
        guard case SettingsAction.toggleSimulation = action else {
            fatalError("unexpected")
        }

        var state = state
        state.simulation.toggle()
        return state
    }

    static let updatePreferredFigureReducer: Reducer<Self> = { state, action in
        guard case let SettingsAction.updatePreferredFigure(value) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.preferredFigure = value
        return state
    }
}

public extension SettingsState {
    class Builder {
        private var playersCount: Int = 0
        private var waitDelayMilliseconds: Int = 0
        private var simulation: Bool = false
        private var preferredFigure: String?

        public func build() -> SettingsState {
            .init(
                playersCount: playersCount,
                waitDelayMilliseconds: waitDelayMilliseconds,
                simulation: simulation,
                preferredFigure: preferredFigure
            )
        }

        public func withPlayersCount(_ value: Int) -> Self {
            playersCount = value
            return self
        }

        public func withSimulation(_ value: Bool) -> Self {
            simulation = value
            return self
        }

        public func withWaitDelayMilliseconds(_ value: Int) -> Self {
            waitDelayMilliseconds = value
            return self
        }

        public func withPreferredFigure(_ value: String?) -> Self {
            preferredFigure = value
            return self
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}
