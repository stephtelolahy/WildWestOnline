//
//  SettingsDestination.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 12/09/2024.
//
import Redux

public enum SettingsDestination: String, Destination {
    case figures

    public var id: String {
        self.rawValue
    }
}

extension NavigationState {
    static let settingsReducer: Reducer<Self, NavigationAction<SettingsDestination>> = { state, action in
        var state = state
        switch action {
        case .push(let page):
            state.settings.path.append(page)

        case .pop:
            state.settings.path.removeLast()

        case .setPath(let path):
            state.settings.path = path

        case .present(let page):
            state.settings.sheet = page

        case .dismiss:
            state.settings.sheet = nil
        }

        return state
    }
}
