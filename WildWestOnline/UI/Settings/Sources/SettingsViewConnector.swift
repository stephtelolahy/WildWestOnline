//
//  SettingsViewConnector.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 10/05/2024.
//
import AppCore
import Redux
import SettingsCore

public enum SettingsViewConnector: Connector {
    public static func deriveState(_ state: AppState) -> SettingsView.State? {
        .init(
            playersCount: state.settings.playersCount,
            speedIndex: indexOfSpeed(state.settings.waitDelayMilliseconds),
            simulation: state.settings.simulation,
            figureOptions: state.settings.inventory.figures,
            preferredFigureIndex: indexOfFigure(state.settings.preferredFigure, in: state.settings.inventory.figures)
        )
    }

    public static func embedAction(_ action: SettingsView.Action) -> AppAction {
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

    private static func indexOfSpeed(_ delayMilliseconds: Int) -> Int {
        SettingsView.State.SpeedOption.all.firstIndex { $0.value == delayMilliseconds } ?? 0
    }

    private static func indexOfFigure(_ figure: String?, in figures: [String]) -> Int {
        guard let figure,
              let index = figures.firstIndex(of: figure) else {
            return -1
        }

        return index
    }
}
