// swiftlint:disable:this file_name
//
//  SettingsViewState.swift
//
//
//  Created by Hugues Telolahy on 09/12/2023.
//
// swiftlint:disable nesting no_magic_numbers
import AppCore

public extension SettingsView {
    struct State: Equatable {
        public let minPlayersCount = 2
        public let maxPlayersCount = 7
        public let speedOptions: [SpeedOption] = SpeedOption.all
        public let playersCount: Int
        public let speedIndex: Int
        public let simulation: Bool
        public let figureOptions: [String]
        public let preferredFigureIndex: Int

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
    }

    static let deriveState: (AppState) -> State? = { state in
            .init(
                playersCount: state.settings.playersCount,
                speedIndex: State.indexOfSpeed(state.settings.waitDelayMilliseconds),
                simulation: state.settings.simulation,
                figureOptions: state.settings.inventory.figures,
                preferredFigureIndex: State.indexOfFigure(state.settings.preferredFigure, in: state.settings.inventory.figures)
            )
    }
}

private extension SettingsView.State {
    static func indexOfSpeed(_ delayMilliseconds: Int) -> Int {
        SpeedOption.all.firstIndex { $0.value == delayMilliseconds } ?? 0
    }

    static func indexOfFigure(_ figure: String?, in figures: [String]) -> Int {
        guard let figure,
              let index = figures.firstIndex(of: figure) else {
            return -1
        }

        return index
    }
}