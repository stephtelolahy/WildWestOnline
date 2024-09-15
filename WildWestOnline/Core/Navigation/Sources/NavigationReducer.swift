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

        if let action = action as? NavigationStackAction<RootDestination> {
            state.root = try stackReducer(state.root, action)
        }

        if let action = action as? NavigationStackAction<SettingsDestination> {
            state.settings = try stackReducer(state.settings, action)
        }

        return state
    }
}

private func stackReducer<T: Destination>(_ state: NavigationStackState<T>, _ action: NavigationStackAction<T>) throws -> NavigationStackState<T> {
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
