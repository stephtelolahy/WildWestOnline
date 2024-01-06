//
//  NavState.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//
import Redux

public typealias NavState = [Screen]

public extension NavState {
    static let reducer: Reducer<Self> = { state, action in
        guard let action = action as? NavAction else {
            return state
        }

        var state = state
        switch action {
        case let .showScreen(screen, transition):
            switch transition {
            case .push:
                state.append(screen)

            case .replace:
                state = [screen]
            }

        case .dismiss:
            state.removeLast()
        }

        return state
    }
}
