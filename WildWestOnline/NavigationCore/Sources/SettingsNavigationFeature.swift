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
        }

        public init(path: [Destination] = []) {
            self.path = path
        }
    }

    public enum Action: ActionProtocol {
        case push(State.Destination)
        case pop
        case setPath([State.Destination])
    }

    public static func reduce(
        into state: inout State,
        action: ActionProtocol,
        dependencies: Void
    ) -> Effect {
        guard let action = action as? Action else {
            return .none
        }

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
