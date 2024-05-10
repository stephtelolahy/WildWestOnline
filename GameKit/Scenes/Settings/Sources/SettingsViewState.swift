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

        public let minPlayersCount = 2
        public let maxPlayersCount = 7
        public let speedOptions: [SpeedOption] = SpeedOption.all
        public let playersCount: Int
        public let speedIndex: Int
        public let simulation: Bool
        public let gamePlay: Int
        public let figureOptions: [String]
        public let preferredFigureIndex: Int
    }
}

public extension SettingsView.State {
    static func from(globalState: AppState) -> Self? {
        .init(
            playersCount: globalState.settings.playersCount,
            speedIndex: indexOfSpeed(globalState.settings.waitDelayMilliseconds),
            simulation: globalState.settings.simulation,
            gamePlay: globalState.settings.gamePlay,
            figureOptions: globalState.settings.inventory.figures,
            preferredFigureIndex: indexOfFigure(globalState.settings.preferredFigure, in: globalState.settings.inventory.figures)
        )
    }

    private static func indexOfSpeed(_ delayMilliseconds: Int) -> Int {
        SpeedOption.all.firstIndex { $0.value == delayMilliseconds } ?? 0
    }

    private static func indexOfFigure(_ figure: String?, in figures: [String]) -> Int {
        guard let figure,
              let index = figures.firstIndex(of: figure) else {
            return -1
        }

        return index
    }
}
