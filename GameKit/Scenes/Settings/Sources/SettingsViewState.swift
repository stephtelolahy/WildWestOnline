// swiftlint:disable:this file_name
//
//  SettingsViewState.swift
//
//
//  Created by Hugues Telolahy on 09/12/2023.
//

import AppCore
import Redux

public extension SettingsView {
    struct State: Equatable {
        public let playersCount: Int
        public let waitDelayMilliseconds: Int
        public let simulation: Bool
    }
}

public extension SettingsView.State {
    static func from(globalState: AppState) -> Self? {
        .init(
            playersCount: globalState.settings.playersCount,
            waitDelayMilliseconds: globalState.settings.waitDelayMilliseconds,
            simulation: globalState.settings.simulation
        )
    }
}
