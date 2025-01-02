//
//  SettingsState.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//

public struct SettingsState: Codable, Equatable {
    public var playersCount: Int
    public var actionDelayMilliSeconds: Int
    public var simulation: Bool
    public var preferredFigure: String?
}

public extension SettingsState {
    class Builder {
        private var playersCount: Int = 0
        private var actionDelayMilliSeconds: Int = 0
        private var simulation: Bool = false
        private var preferredFigure: String?

        public func build() -> SettingsState {
            .init(
                playersCount: playersCount,
                actionDelayMilliSeconds: actionDelayMilliSeconds,
                simulation: simulation,
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

        public func withActionDelayMilliSeconds(_ value: Int) -> Self {
            actionDelayMilliSeconds = value
            return self
        }

        public func withPreferredFigure(_ value: String?) -> Self {
            preferredFigure = value
            return self
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}
