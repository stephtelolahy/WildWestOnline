// swiftlint:disable:this file_name
//
//  SettingsViewState.swift
//
//
//  Created by Hugues Telolahy on 09/12/2023.
//
// swiftlint:disable nesting no_magic_numbers

import AppCore
import Redux

public extension SettingsView {
    struct State: Equatable {
        // MARK: - Constants

        public let minPlayersCount = 2
        public let maxPlayersCount = 7
        public let speedOptions: [SpeedOption] = SpeedOption.all

        public struct SpeedOption: Equatable {
            let label: String
            let value: Int

            static let all: [Self] = [
                .init(label: "Normal", value: 500),
                .init(label: "Slow", value: 1000),
                .init(label: "Fast", value: 0)
            ]
        }

        public let gamePlayOptions: [String] = [
            "UIKit",
            "SwiftUI"
        ]

        // MARK: - Instance variables

        public let playersCount: Int
        public let currentSpeedIndex: Int
        public let simulation: Bool
        public let gamePlay: Int
        public let figures: [String]
        public let preferredFigure: Int
    }
}

public extension SettingsView.State {
    static func from(globalState: AppState) -> Self? {
        .init(
            playersCount: globalState.settings.playersCount,
            currentSpeedIndex: globalState.speedOptionIndex,
            simulation: globalState.settings.simulation,
            gamePlay: globalState.settings.gamePlay,
            figures: globalState.settings.inventory.figures,
            preferredFigure: globalState.settings.preferredFigure
        )
    }
}

private extension AppState {
    var speedOptionIndex: Int {
        SettingsView.State.SpeedOption.all.firstIndex {
            $0.value == settings.waitDelayMilliseconds
        } ?? 0
    }
}
