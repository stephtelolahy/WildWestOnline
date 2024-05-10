//
//  SettingsViewConnector.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 10/05/2024.
//
import AppCore
import Redux

public extension Connectors {
    struct SettingsViewConnector: Connector {

        public init() {}

        public func connect(state: AppState) -> SettingsView.State {
            .init(
                playersCount: state.settings.playersCount,
                speedIndex: indexOfSpeed(state.settings.waitDelayMilliseconds),
                simulation: state.settings.simulation,
                gamePlay: state.settings.gamePlay,
                figureOptions: state.settings.inventory.figures,
                preferredFigureIndex: indexOfFigure(state.settings.preferredFigure, in: state.settings.inventory.figures)
            )
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
