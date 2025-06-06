//
//  Dispatch.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import Combine
import Redux
@testable import GameCore

func dispatch(
    _ action: GameFeature.Action,
    state: GameFeature.State
) async throws(Card.Failure) -> GameFeature.State {
    let sut = await createGameStore(initialState: state)
    var receivedErrors: [Card.Failure] = []
    var cancellables: Set<AnyCancellable> = []
    await MainActor.run {
        sut.$state
            .sink { state in
                if let error = state.lastActionError {
                    receivedErrors.append(error)
                }
            }
            .store(in: &cancellables)
    }

    // When
    await sut.dispatch(action)

    // Then
    guard receivedErrors.isEmpty else {
        throw receivedErrors[0]
    }

    return await sut.state
}

@MainActor private func createGameStore(initialState: GameFeature.State) -> Store<GameFeature.State, Void> {
    .init(
        initialState: initialState,
        reducer: GameFeature.reduceMechanics,
        dependencies: ()
    )
}
