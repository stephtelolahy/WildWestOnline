//
//  HomeFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 04/12/2025.
//

import Redux

public enum HomeFeature {
    public struct State: Equatable, Sendable {
        public init() {}
    }

    public enum Action {
        case playTapped
        case settingsTapped

        case delegate(Delegate)

        public enum Delegate {
            case play
            case settings
        }
    }

    public static func reducer(
        state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        switch action {
        case .playTapped:
            return .run { .delegate(.play) }

        case .settingsTapped:
            return .run { .delegate(.settings) }

        case .delegate:
            return .none
        }
    }
}
