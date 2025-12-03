//
//  SettingsNavigationFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 29/03/2025.
//

import Redux

public enum SettingsNavigationFeature {
    public struct State: Equatable, Codable, Sendable {
        public var path: [Destination]

        public enum Destination: String, Codable, Sendable {
            case figures
            case collectibles
        }

        public init(path: [Destination] = []) {
            self.path = path
        }
    }

    public enum Action {
        case push(State.Destination)
        case pop
        case setPath([State.Destination])
    }

    public static func reducer(
        into state: inout State,
        action: Action,
        dependencies: Void
    ) -> Effect<Action> {
        switch action {
        case .push(let page):
            state.path.append(page)

        case .pop:
            state.path.removeLast()

        case .setPath(let path):
            state.path = path
        }

        return .none
    }
}
