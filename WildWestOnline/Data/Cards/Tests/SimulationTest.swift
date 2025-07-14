//
//  SimulationTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2023.
//

import Testing
import Redux
import CardsData
import Combine
@testable import GameCore

struct SimulationTest {
    @Test func simulate2PlayersGame_shouldComplete() async throws {
        try await simulateGame(playersCount: 3)
    }

    private func simulateGame(playersCount: Int) async throws {
        // Given
        let deck = GameSetupService.buildDeck(deck: Deck.bang).shuffled()
        let figures = Array(Figures.allNames.shuffled().prefix(playersCount))
        var state = GameSetupService.buildGame(
            figures: figures,
            deck: deck,
            cards: Cards.all,
            playerAbilities: PlayerAbilities.allNames
        )
        for player in state.playOrder {
            state.playMode[player] = .auto
        }

        let store = await createGameStore(initialState: state)

        let stateVerifier = StateVerifier(initialState: state)
        var cancellables: Set<AnyCancellable> = []
        await MainActor.run {
            store.dispatchedAction
                .sink {
                    stateVerifier.receiveAction(action: $0)
                    print($0)
                }
                .store(in: &cancellables)
            store.$state
                .sink {
                    stateVerifier.receiveState(state: $0)
                }
                .store(in: &cancellables)
        }

        // When
        let startAction = GameFeature.Action.startTurn(player: state.playOrder[0])
        await store.dispatch(startAction)

        // Then
        await #expect(store.state.isOver, "Expected game over")
    }
}

@MainActor private func createGameStore(initialState: GameFeature.State) -> Store<GameFeature.State, Void> {
    .init(
        initialState: initialState,
        reducer: GameFeature.reduce,
        dependencies: ()
    )
}

/// Verify State integrity by applying action to previous State
private class StateVerifier {
    var prevState: GameFeature.State
    var currentState: GameFeature.State

    init(initialState: GameFeature.State) {
        self.prevState = initialState
        self.currentState = initialState
    }

    func receiveState(state: GameFeature.State) {
        prevState = currentState
        currentState = state
    }

    func receiveAction(action: ActionProtocol) {
        var nextState = prevState
        _ = GameFeature.reduceMechanics(into: &nextState, action: action, dependencies: ())
        assert(nextState == currentState, "Inconsistent state after applying \(action)")
    }
}
