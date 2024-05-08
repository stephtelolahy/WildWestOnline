//
//  SettingsState+Builder.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 08/05/2024.
//
import GameCore

public extension SettingsState {
    class Builder {
        private var inventory: Inventory = Inventory.makeBuilder().build()
        private var playersCount: Int = 0
        private var waitDelayMilliseconds: Int = 0
        private var simulation: Bool = false
        private var gamePlay: Int = 0
        private var preferredFigure: String?

        public func build() -> SettingsState {
            .init(
                inventory: inventory,
                playersCount: playersCount,
                waitDelayMilliseconds: waitDelayMilliseconds,
                simulation: simulation,
                gamePlay: gamePlay,
                preferredFigure: preferredFigure
            )
        }

        public func withPlayersCount(_ value: Int) -> Self {
            playersCount = value
            return self
        }

        public func withSimulation(_ value: Bool) -> Self {
            simulation = value
            return self
        }

        public func withWaitDelayMilliseconds(_ value: Int) -> Self {
            waitDelayMilliseconds = value
            return self
        }

        public func withInventory(_ value: Inventory) -> Self {
            inventory = value
            return self
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}
