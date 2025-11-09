//
//  Dispatch.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import Combine
import Redux
@testable import GameFeature

@MainActor func dispatch(
    _ action: GameFeature.Action,
    state: GameFeature.State
) async throws(GameFeature.Error) -> GameFeature.State {
    let sut = Store(
        initialState: state,
        reducer: GameFeature.reducerMechanics,
        dependencies: ()
    )
    var receivedErrors: [GameFeature.Error] = []
    var cancellables: Set<AnyCancellable> = []
    sut.$state
        .sink { state in
            if let error = state.lastError {
                receivedErrors.append(error)
            }
        }
        .store(in: &cancellables)

    // When
    await sut.dispatch(action)

    // Then
    if !receivedErrors.isEmpty {
        throw receivedErrors[0]
    }

    return sut.state
}
