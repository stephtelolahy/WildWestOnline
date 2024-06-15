// swiftlint:disable:this file_name
//
//  SettingsCore.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 15/06/2024.
//
import GameCore
import Redux

public enum Settings {
    public struct State: Codable, Equatable {
        public let inventory: Inventory
        public var playersCount: Int
        public var waitDelayMilliseconds: Int
        public var simulation: Bool
        public var preferredFigure: String?
    }

    public enum Action: Codable, Equatable {
        case updatePlayersCount(Int)
        case updateWaitDelayMilliseconds(Int)
        case toggleSimulation
        case updatePreferredFigure(String?)
    }

    public static var reducer: Reducer<State, Action> = { state, action in
        var  state = state

        switch action {
        case let .updatePlayersCount(value):
            state.playersCount = value

        case let .updateWaitDelayMilliseconds(value):
            state.waitDelayMilliseconds = value

        case .toggleSimulation:
            state.simulation.toggle()

        case let .updatePreferredFigure(value):
            state.preferredFigure = value
        }

        return state
    }

    public class SaveMiddleware: Middleware<State, Action> {
        private var service: SettingsService

        public init(service: SettingsService) {
            self.service = service
            super.init()
        }

        public override func handle(_ action: Action, state: State) async -> Action? {
            switch action {
            case let .updatePlayersCount(value):
                service.playersCount = value

            case let .updateWaitDelayMilliseconds(delay):
                service.waitDelayMilliseconds = delay

            case .toggleSimulation:
                service.simulationEnabled = state.simulation

            case let .updatePreferredFigure(value):
                service.preferredFigure = value
            }

            return nil
        }
    }
}
