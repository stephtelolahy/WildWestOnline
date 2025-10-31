//
//  SettingsState+Builder.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//
public extension SettingsFeature.State {
    class Builder {
        private var playersCount: Int = 0
        private var actionDelayMilliSeconds: Int = 0
        private var simulation: Bool = false
        private var preferredFigure: String?
        private var musicVolume: Float = 1.0

        public func build() -> SettingsFeature.State {
            .init(
                playersCount: playersCount,
                actionDelayMilliSeconds: actionDelayMilliSeconds,
                simulation: simulation,
                preferredFigure: preferredFigure,
                musicVolume: musicVolume
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

        public func withActionDelayMilliSeconds(_ value: Int) -> Self {
            actionDelayMilliSeconds = value
            return self
        }

        public func withPreferredFigure(_ value: String?) -> Self {
            preferredFigure = value
            return self
        }

        public func withMusicVolume(_ value: Float) -> Self {
            musicVolume = value
            return self
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}
