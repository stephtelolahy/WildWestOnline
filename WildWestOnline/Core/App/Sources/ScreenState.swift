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
    static let reducer: ThrowingReducer<Self> = { state, action in
        switch action {
        case AppAction.navigate:
            try navigateReducer(state, action)

        case AppAction.close:
            try closeReducer(state, action)

        default:
            state
        }
    }
}

private extension ScreenState {
    static let navigateReducer: ThrowingReducer<Self> = { state, action in
        guard case let AppAction.navigate(screen) = action else {
            fatalError("unexpected")
        }

        var state = state
        if case .splash = state.last {
            state = []
        }
        state.append(screen)
        return state
    }

    static let closeReducer: ThrowingReducer<Self> = { state, action in
        guard case AppAction.close = action else {
            fatalError("unexpected")
        }

        var state = state
        state.removeLast()
        return state
    }
}
