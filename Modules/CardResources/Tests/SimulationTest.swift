//
//  SimulationTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2023.
//

import Testing
import Redux
import Combine
@testable import GameFeature
@testable import CardResources

struct SimulationTest {
    @Test func simulateGame_shouldComplete() async throws {
        try await simulateGame(playersCount: 7)
    }

    @MainActor
    private func simulateGame(playersCount: Int) async throws {
        // Given
        let state = GameSetup.buildGame(
            playersCount: playersCount,
            cards: Cards.all,
            deck: Deck.bang,
            actionDelayMilliSeconds: 0,
            playModeSetup: .allAuto
        )

        let dependencies = GameFeature.Dependencies(
            registry: .init(
                handlers: [
                    IncrementCardsPerTurnModifier.self
                ]
            )
        )

        let store = Store(
            initialState: state,
            reducer: GameFeature.reducer,
            dependencies: dependencies
        )

        var prevState = state
        var currentState = state
        var cancellables: Set<AnyCancellable> = []

        store.$state
            .sink {
                prevState = currentState
                currentState = $0
                if let error = $0.lastError {
                    print("⚠️ \(error)")
                }
            }
            .store(in: &cancellables)

        store.dispatchedAction
            .sink {
                print($0)
                var nextState = prevState
                _ = GameFeature.reducerMechanics(into: &nextState, action: $0, dependencies: dependencies)
                #expect(nextState == currentState, "Inconsistent state after applying \($0)")
            }
            .store(in: &cancellables)

        // When
        let startAction = GameFeature.Action.startTurn(player: state.playOrder[0])
        await store.dispatch(startAction)

        // Then
        #expect(store.state.isOver, "Expected game over")
    }
}
