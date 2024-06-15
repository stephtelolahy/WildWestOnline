// swiftlint:disable:this file_name
//
//  SettingsViewModel.swift
//
//
//  Created by Hugues Telolahy on 09/12/2023.
//
// swiftlint:disable nesting no_magic_numbers
import AppCore
import Redux
import SettingsCore

public extension SettingsView {
    struct State: Equatable {
        public let minPlayersCount = 2
        public let maxPlayersCount = 7
        public let speedOptions: [SpeedOption] = SpeedOption.all
        public let playersCount: Int
        public let speedIndex: Int
        public let simulation: Bool
        public let figureOptions: [String]
        public let preferredFigureIndex: Int

        public struct SpeedOption: Equatable {
            let label: String
            let value: Int

            static let all: [Self] = [
                .init(label: "Normal", value: 500),
                .init(label: "Slow", value: 1000),
                .init(label: "Fast", value: 0)
            ]
        }
    }

    enum Action {
        case didTapCloseButton
        case didSelectFigure(String)
        case didSelectSpeed(Int)
        case didSelectPlayersCount(Int)
        case didToggleSimulation
    }

    struct Connector: Redux.Connector {
        public init() {}

        public func deriveState(_ state: AppState) -> State? {
            .init(
                playersCount: state.settings.playersCount,
                speedIndex: indexOfSpeed(state.settings.waitDelayMilliseconds),
                simulation: state.settings.simulation,
                figureOptions: state.settings.inventory.figures,
                preferredFigureIndex: indexOfFigure(state.settings.preferredFigure, in: state.settings.inventory.figures)
            )
        }

        public func embedAction(_ action: Action) -> AppAction {
            switch action {
            case .didTapCloseButton:
                    .close

            case .didSelectFigure(let figure):
                    .settings(.updatePreferredFigure(figure))

            case .didSelectSpeed(let delay):
                    .settings(.updateWaitDelayMilliseconds(delay))

            case .didSelectPlayersCount(let count):
                    .settings(.updatePlayersCount(count))

            case .didToggleSimulation:
                    .settings(.toggleSimulation)
            }
        }

        private func indexOfSpeed(_ delayMilliseconds: Int) -> Int {
            SettingsView.State.SpeedOption.all.firstIndex { $0.value == delayMilliseconds } ?? 0
        }

        private func indexOfFigure(_ figure: String?, in figures: [String]) -> Int {
            guard let figure,
                  let index = figures.firstIndex(of: figure) else {
                return -1
            }

            return index
        }
    }

}
