//
//  SettingsRootViewModel.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 16/10/2025.
//
import Redux
import AppCore

extension SettingsRootView {
    struct ViewState: Equatable {
        let minPlayersCount = 2
        let maxPlayersCount = 7
        let speedOptions: [SpeedOption] = SpeedOption.all
        let playersCount: Int
        let speedIndex: Int
        let simulation: Bool
        let preferredFigure: String?

        struct SpeedOption: Equatable {
            let label: String
            let value: Int

            static let all: [Self] = [
                .init(label: "Normal", value: 500),
                .init(label: "Fast", value: 0)
            ]
        }
    }

    typealias ViewStore = Store<ViewState, AppFeature.Action, Void>
}

extension SettingsRootView.ViewState {
    init?(appState: AppFeature.State) {
        playersCount = appState.settings.playersCount
        speedIndex = SpeedOption.all.firstIndex { $0.value == appState.settings.actionDelayMilliSeconds } ?? 0
        simulation = appState.settings.simulation
        preferredFigure = appState.settings.preferredFigure
    }
}
