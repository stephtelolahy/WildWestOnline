//
//  ScreenState.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 20/07/2024.
//
import Redux

public typealias ScreenState = [Screen]

public enum Screen: Codable, Equatable {
    case splash
    case home
    case game
    case settings
}

public extension ScreenState {
    static let reducer: Reducer<Self, NavigationAction> = { state, action in
        switch action {
        case .navigate:
            try navigateReducer(state, action)

        case .close:
            try closeReducer(state, action)
        }
    }
}

private extension ScreenState {
    static let navigateReducer: Reducer<Self, NavigationAction> = { state, action in
        guard case let .navigate(screen) = action else {
            fatalError("unexpected")
        }

        var state = state
        if case .splash = state.last {
            state = []
        }
        state.append(screen)
        return state
    }

    static let closeReducer: Reducer<Self, NavigationAction> = { state, action in
        guard case .close = action else {
            fatalError("unexpected")
        }

        var state = state
        state.removeLast()
        return state
    }
}
