//
//  Dispatch.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import Redux
import GameCore
import Combine

func dispatch(
    _ action: GameAction,
    state: GameState
) async throws -> GameState {
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

@MainActor private func createGameStore(initialState: GameState) -> Store<GameState, Void> {
    .init(
        initialState: initialState,
        reducer: gameReducer,
        dependencies: ()
    )
}
