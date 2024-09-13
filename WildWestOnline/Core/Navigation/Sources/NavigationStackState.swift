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

public extension NavigationStackState {
    mutating func reducer(action: NavigationAction<T>) {
        switch action {
        case .push(let page):
            path.append(page)

        case .pop:
            path.removeLast()

        case .setPath(let newPath):
            path = newPath

        case .present(let page):
            sheet = page

        case .dismiss:
            sheet = nil
        }
    }
}
