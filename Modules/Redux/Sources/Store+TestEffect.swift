//
//  Store+TestEffect.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 22/02/2026.
//

import Combine

public extension Store {
    @MainActor
    func receive(_ action: Action) async -> [Action] {
        var dispatchedActions: [Action] = []
        var cancellables: Set<AnyCancellable> = []
        self.dispatchedAction.sink {
            dispatchedActions.append($0)
        }
        .store(in: &cancellables)

        await self.dispatch(action)

        // Then
        return Array(dispatchedActions.dropFirst())
    }
}
