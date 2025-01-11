//
//  SimulationTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2023.
//

import Testing
import Redux
import GameCore
import CardsData

struct SimulationTest {
    @Test func simulate2PlayersGame_shouldComplete() async throws {
        try await simulateGame(playersCount: 3)
    }

    private func simulateGame(playersCount: Int) async throws {
        // Given
        let deck = Setup.buildDeck(cardSets: CardSets.bang).shuffled()
        let figures = Array(Figures.bang.shuffled().prefix(playersCount))
        var state = Setup.buildGame(figures: figures, deck: deck, cards: Cards.all, defaultAbilities: DefaultAbilities.all)
        for player in state.playOrder {
            state.playMode[player] = .auto
        }

        let store = await createGameStoreWithAIAgent(initialState: state)

        // When
        let startAction = GameAction.startTurn(player: state.playOrder[0])
        await store.dispatch(startAction)

        // Then
        await #expect(store.state.isOver, "Expected game over")
    }
}

@MainActor private func createGameStoreWithAIAgent(initialState: GameState) -> Store<GameState, Void> {
    .init(
        initialState: initialState,
        reducer: { state, action, dependencies in
                .group([
                    try loggerReducer(state: &state, action: action, dependencies: dependencies),
                    try gameReducer(state: &state, action: action, dependencies: dependencies),
                    try updateGameReducer(state: &state, action: action, dependencies: dependencies),
                    try playAIMoveReducer(state: &state, action: action, dependencies: dependencies)
                ])
        },
        dependencies: ()
    )
}

private func loggerReducer(
    state: inout GameState,
    action: Action,
    dependencies: Void
) throws -> Effect {
    .run {
        print(action)
        return nil
    }
}

/*
private extension Middlewares {
    static func verifyState(_ prevState: StateWrapper) -> Middleware<GameState> {
        { state, action in
            DispatchQueue.main.async {
                guard let nextState = try? GameReducer().reduce(prevState.value, action) else {
                    fatalError("Failed reducing \(action)")
                }

                assert(nextState == state, "Inconsistent state after applying \(action)")

                prevState.value = nextState
            }

            return nil
        }
    }
}

private class StateWrapper: @unchecked Sendable {
    var value: GameState

    init(value: GameState) {
        self.value = value
    }
}
*/
