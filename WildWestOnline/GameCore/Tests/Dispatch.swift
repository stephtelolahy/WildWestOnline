//
//  Dispatch.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import Combine
import Redux
@testable import GameCore

@MainActor func dispatch(
    _ action: GameFeature.Action,
    state: GameFeature.State
) async throws(Card.PlayError) -> GameFeature.State {
    let sut = createGameStore(initialState: state)
    var receivedErrors: [Card.PlayError] = []
    var cancellables: Set<AnyCancellable> = []
    sut.$state
        .sink { state in
            if let error = state.lastActionError {
                receivedErrors.append(error)
            }
        }
        .store(in: &cancellables)

    // When
    await sut.dispatch(action)

    // Then
    guard receivedErrors.isEmpty else {
        throw receivedErrors[0]
    }

    return sut.state
}

@MainActor private func createGameStore(initialState: GameFeature.State) -> Store<GameFeature.State, Void> {
    .init(
        initialState: initialState,
        reducer: GameFeature.reduceMechanics,
        dependencies: ()
    )
}
