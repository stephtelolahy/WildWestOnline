//
//  NavigationStackCore.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import Redux

public protocol Destination: Identifiable, Hashable, Codable, Sendable {}

public struct NavigationStackState<T: Destination>: Equatable, Codable, Sendable {
    public var path: [T]
    public var sheet: T?

    public init(path: [T], sheet: T? = nil) {
        self.path = path
        self.sheet = sheet
    }
}

public enum NavigationStackAction<T: Destination>: Sendable {
    case push(T)
    case pop
    case setPath([T])
    case present(T)
    case dismiss
}

public func navigationStackReducer<T: Destination>(
    state: inout NavigationStackState<T>,
    action: NavigationStackAction<T>,
    dependencies: Void
) -> Effect<NavigationStackState<T>> {
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

    return .none
}
