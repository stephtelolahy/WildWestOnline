//
//  NavigationState.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 07/09/2024.
//
import Redux

public struct NavigationState: Equatable, Codable {
    public var path: [Page]
    public var sheet: Page?
    public var settingsPath: [Page]

    public init(
        path: [Page] = [],
        sheet: Page? = nil,
        settingsPath: [Page] = []
    ) {
        self.path = path
        self.sheet = sheet
        self.settingsPath = settingsPath
    }
}

public enum Page: String, Identifiable, Codable {
    case splash
    case home
    case game

    case settings
    case settingsMain
    case settingsFigure

    public var id: String {
        self.rawValue
    }
}

public extension NavigationState {
    static let reducer: Reducer<Self, NavigationAction> = { state, action in
        var state = state
        switch action {
        case .push(let page):
            if case .splash = state.path.last {
                state.path = []
            }
            state.path.append(page)

        case .pop:
            state.path.removeLast()

        case .present(let sheet):
            state.sheet = sheet

        case .dismiss:
            state.sheet = nil
        }

        return state
    }
}
