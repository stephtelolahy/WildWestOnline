//
//  SettingsNavigationState.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 10/09/2024.
//

import Redux

public struct SettingsNavigationState: Equatable, Codable {
    public enum Destination: String, Identifiable, Codable {
        case figures

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

public enum SettingsNavigationAction {
    case push(SettingsNavigationState.Destination)
    case pop
}

public extension SettingsNavigationState {
    static let reducer: Reducer<Self, SettingsNavigationAction> = { state, action in
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
