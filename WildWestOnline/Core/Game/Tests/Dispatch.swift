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
) async throws -> GameFeature.State {
    let sut = await createGameStore(initialState: state)
    var receivedErrors: [Error] = []
    var cancellables: Set<AnyCancellable> = []
    await MainActor.run {
        sut.errorPublisher
            .sink { receivedErrors.append($0) }
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
