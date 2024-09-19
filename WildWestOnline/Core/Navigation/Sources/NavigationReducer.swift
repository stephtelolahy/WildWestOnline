//
//  NavigationReducer.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//

import Redux

public extension NavigationState {
    static let reducer: Reducer<Self> = { state, action in
        var state = state
        state.main = try stackReducer(state.main, action)
        state.settings = try stackReducer(state.settings, action)
        return state
    }
}

private func stackReducer<T: Destination>(_ state: NavigationStackState<T>, _ action: Action) throws -> NavigationStackState<T> {
    guard let action = action as? NavigationStackAction<T> else {
        return state
    }

    var state = state
    switch action {
    case .push(let page):
        state.path.append(page)

    case .pop:
        state.path.removeLast()

    case .setPath(let path):
        state.path = path

    case .present(let page):
        state.sheet = page

    case .dismiss:
        state.sheet = nil
    }

    return state
}
