//
//  RootNavigationState.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 09/09/2024.
//
import Redux

public struct RootNavigationState: Equatable, Codable {
    public enum Destination: String, Identifiable, Codable {
        case home
        case game
        case settings

        public var id: String {
            self.rawValue
        }
    }

    public var path: [Destination]
    public var sheet: Destination?

    public init(path: [Destination], sheet: Destination? = nil) {
        self.path = path
        self.sheet = sheet
    }
}

public enum RootNavigationAction {
    case push(RootNavigationState.Destination)
    case pop
}

public extension RootNavigationState {
    static let reducer: Reducer<Self, RootNavigationAction> = { state, action in
        var state = state
        switch action {
        case .push(let page):
            state.path.append(page)

        case .pop:
            state.path.removeLast()
        }

        return state
    }
}
