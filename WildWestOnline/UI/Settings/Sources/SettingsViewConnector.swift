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

public struct SettingsViewConnector: Connector {
    public init() {}

    public func deriveState(_ state: AppState) -> SettingsView.State? {
        .init(
            playersCount: state.settings.playersCount,
            speedIndex: SettingsView.State.indexOfSpeed(state.settings.waitDelayMilliseconds),
            simulation: state.settings.simulation,
            preferredFigure: state.settings.preferredFigure
        )
    }

    public func embedAction(_ action: SettingsView.Action, _ state: AppState) -> Any {
        switch action {
        case .didTapCloseButton:
            RootNavigationAction.dismiss

        case .didChangePlayersCount(let count):
            SettingsAction.updatePlayersCount(count)

        case .didChangeWaitDelay(let delay):
            SettingsAction.updateWaitDelayMilliseconds(delay)

        case .didToggleSimulation:
            SettingsAction.toggleSimulation

        case .didTapFigures:
            SettingsNavigationAction.push(.figures)
        }
    }
}

private extension SettingsView.State {
    static func indexOfSpeed(_ delayMilliseconds: Int) -> Int {
        SpeedOption.all.firstIndex { $0.value == delayMilliseconds } ?? 0
    }
}
