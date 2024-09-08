//
//  NavigationState.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 07/09/2024.
//
import Redux

public struct NavigationState: Equatable, Codable {
    public var root: Page
    public var path: [Page]
    public var sheet: Page?

    public init(
        root: Page = .splash,
        path: [Page] = [],
        sheet: Page? = nil
    ) {
        self.root = root
        self.path = path
        self.sheet = sheet
    }
}

public indirect enum Page: Identifiable, Equatable, Codable {
    case splash
    case home
    case game

    case settingsMain
    case settingsFigure

    case stack(root: Self, path: [Self] = [])

    public var id: String {
        String(describing: self)
    }
}

public extension NavigationState {
    static let reducer: Reducer<Self, NavigationAction> = { state, action in
        var state = state
        switch action {
        case .push(let page):
            assert(state.sheet == nil, "TODO")
            state.path.append(page)

        case .pop:
            assert(state.sheet == nil, "TODO")
            state.path.removeLast()

        case .present(let sheet):
            state.sheet = sheet

        case .dismiss:
            state.sheet = nil
        }

        return state
    }
}
