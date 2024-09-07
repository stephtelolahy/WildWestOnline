// swiftlint:disable:this file_name
//
//  SettingsViewState.swift
//
//
//  Created by Hugues Telolahy on 09/12/2023.
//
// swiftlint:disable nesting no_magic_numbers
import AppCore
import NavigationCore
import SettingsCore

public extension SettingsView {
    struct State: Equatable {
        public let minPlayersCount = 2
        public let maxPlayersCount = 7
        public let speedOptions: [SpeedOption] = SpeedOption.all
        public let playersCount: Int
        public let speedIndex: Int
        public let simulation: Bool
        public let preferredFigure: String?

        public struct SpeedOption: Equatable {
            let label: String
            let value: Int

            static let all: [Self] = [
                .init(label: "Normal", value: 500),
                .init(label: "Fast", value: 0)
            ]
        }
    }

    enum Action {
        case didTapCloseButton
        case didChangePlayersCount(Int)
        case didChangeWaitDelay(Int)
        case didToggleSimulation
    }

    static let deriveState: (AppState) -> State? = { state in
            .init(
                playersCount: state.settings.playersCount,
                speedIndex: State.indexOfSpeed(state.settings.waitDelayMilliseconds),
                simulation: state.settings.simulation,
                preferredFigure: state.settings.preferredFigure
            )
    }

    static let embedAction: (Action, AppState) -> Any = { action, _ in
        switch action {
        case .didTapCloseButton:
            NavigationAction.dismiss

        case .didChangePlayersCount(let count):
            SettingsAction.updatePlayersCount(count)

        case .didChangeWaitDelay(let delay):
            SettingsAction.updateWaitDelayMilliseconds(delay)

        case .didToggleSimulation:
            SettingsAction.toggleSimulation
        }
    }
}

private extension SettingsView.State {
    static func indexOfSpeed(_ delayMilliseconds: Int) -> Int {
        SpeedOption.all.firstIndex { $0.value == delayMilliseconds } ?? 0
    }
}
