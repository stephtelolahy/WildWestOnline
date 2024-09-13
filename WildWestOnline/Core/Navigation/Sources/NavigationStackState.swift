//
//  NavigationStackState.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 13/09/2024.
//

public protocol Destination: Identifiable, Hashable, Codable {}

public struct NavigationStackState<T: Destination>: Equatable, Codable {
    public var path: [T]
    public var sheet: T?

    public init(path: [T], sheet: T? = nil) {
        self.path = path
        self.sheet = sheet
    }
}

public enum NavigationAction<T: Destination> {
    case push(T)
    case pop
    case setPath([T])
    case present(T)
    case dismiss
}

func stackReducer<T: Destination>(_ state: NavigationStackState<T>, _ action: NavigationAction<T>) throws -> NavigationStackState<T> {
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
