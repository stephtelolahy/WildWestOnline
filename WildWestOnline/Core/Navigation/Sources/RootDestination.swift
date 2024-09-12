//
//  RootDestination.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 12/09/2024.
//
import Redux

public enum RootDestination: String, Destination {
    case home
    case game
    case settings

    public var id: String {
        self.rawValue
    }
}

extension NavigationState {
    static let rootReducer: Reducer<Self, NavigationAction<RootDestination>> = { state, action in
        var state = state
        switch action {
        case .push(let page):
            state.root.path.append(page)

        case .pop:
            state.root.path.removeLast()

        case .setPath(let path):
            state.root.path = path

        case .present(let page):
            state.root.sheet = page

        case .dismiss:
            state.root.sheet = nil
        }

        return state
    }
}
