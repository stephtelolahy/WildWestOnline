//
//  SettingsRootPresenter.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//

import Redux
import AppCore

extension SettingsRootView {
    static let presenter: Presenter<AppState, State> = { state in
            .init(
                playersCount: state.settings.playersCount,
                speedIndex: SettingsRootView.State.indexOfSpeed(state.settings.waitDelayMilliseconds),
                simulation: state.settings.simulation,
                preferredFigure: state.settings.preferredFigure
            )
    }
}

private extension SettingsRootView.State {
    static func indexOfSpeed(_ delayMilliseconds: Int) -> Int {
        SpeedOption.all.firstIndex { $0.value == delayMilliseconds } ?? 0
    }
}
