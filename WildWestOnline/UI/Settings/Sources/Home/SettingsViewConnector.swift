// swiftlint:disable:this file_name
//
//  SettingsViewConnector.swift
//
//
//  Created by Hugues Telolahy on 09/12/2023.
//
// swiftlint:disable nesting no_magic_numbers
import AppCore
import NavigationCore
import SettingsCore
import Redux

struct SettingsViewConnector: Connector {
    func deriveState(_ state: AppState) -> SettingsView.State? {
        .init(
            playersCount: state.settings.playersCount,
            speedIndex: SettingsView.State.indexOfSpeed(state.settings.waitDelayMilliseconds),
            simulation: state.settings.simulation,
            preferredFigure: state.settings.preferredFigure
        )
    }

    func embedAction(_ action: SettingsView.Action) -> Any {
        switch action {
        case .didTapCloseButton:
            NavigationAction<RootDestination>.dismiss

        case .didChangePlayersCount(let count):
            SettingsAction.updatePlayersCount(count)

        case .didChangeWaitDelay(let delay):
            SettingsAction.updateWaitDelayMilliseconds(delay)

        case .didToggleSimulation:
            SettingsAction.toggleSimulation

        case .didTapFigures:
            NavigationAction<SettingsDestination>.push(.figures)
        }
    }
}

private extension SettingsView.State {
    static func indexOfSpeed(_ delayMilliseconds: Int) -> Int {
        SpeedOption.all.firstIndex { $0.value == delayMilliseconds } ?? 0
    }
}
