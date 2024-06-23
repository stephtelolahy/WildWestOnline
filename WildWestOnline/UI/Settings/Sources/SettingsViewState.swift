// swiftlint:disable:this file_name
//
//  SettingsViewState.swift
//
//
//  Created by Hugues Telolahy on 09/12/2023.
//
// swiftlint:disable nesting no_magic_numbers

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
}
