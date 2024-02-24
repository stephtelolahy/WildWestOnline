//
//  SettingsViewState.swift
//
//
//  Created by Hugues Telolahy on 09/12/2023.
//

import AppCore
import Redux

extension SettingsView {
    public struct State: Equatable {
        public let playersCount: Int
        public let waitDelayMilliseconds: Int
        public let simulation: Bool
    }
}

extension SettingsView.State {
    public static func from(globalState: AppState) -> Self? {
        .init(
            playersCount: globalState.settings.playersCount,
            waitDelayMilliseconds: globalState.settings.waitDelayMilliseconds,
            simulation: globalState.settings.simulation
        )
    }
}
