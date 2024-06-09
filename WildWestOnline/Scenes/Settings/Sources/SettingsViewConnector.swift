//
//  SettingsViewConnector.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 10/05/2024.
//
import AppCore
import Redux
import SettingsCore

public extension Connectors {
    struct SettingsViewConnector: Connector {
        public init() {}

        public func deriveState(state: AppState) -> SettingsView.State? {
            .init(
                playersCount: state.settings.playersCount,
                speedIndex: indexOfSpeed(state.settings.waitDelayMilliseconds),
                simulation: state.settings.simulation,
                gamePlay: state.settings.gamePlay,
                figureOptions: state.settings.inventory.figures,
                preferredFigureIndex: indexOfFigure(state.settings.preferredFigure, in: state.settings.inventory.figures)
            )
        }

        public func embedAction(action: SettingsView.Action) -> AppAction {
            switch action {
            case .close:
                AppAction.close

            case .updatePreferredFigure(let figure):
                SettingsAction.updatePreferredFigure(figure)

            case .updateGamePlay(let index):
                SettingsAction.updateGamePlay(index)

            case .updateWaitDelayMilliseconds(let delay):
                SettingsAction.updateWaitDelayMilliseconds(delay)

            case .updatePlayersCount(let count):
                SettingsAction.updatePlayersCount(count)

            case .toggleSimulation:
                SettingsAction.toggleSimulation
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
