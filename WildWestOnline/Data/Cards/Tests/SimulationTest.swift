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

@MainActor private func createGameStoreWithAIAgent(initialState: GameState) -> Store<GameState, GameStoreDependencies> {
    .init(
        initialState: initialState,
        reducer: { state, action, dependencies in
                .group([
                    try loggerReducer(state: &state, action: action, dependencies: ()),
                    try gameReducer(state: &state, action: action, dependencies: ()),
                    try updateGameReducer(state: &state, action: action, dependencies: ()),
                    try playAIMoveReducer(state: &state, action: action, dependencies: ()),
                    try verifyStateReducer(state: &state, action: action, dependencies: dependencies.stateHolder)
                ])
        },
        dependencies: .init(stateHolder: .init(value: initialState))
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

private func verifyStateReducer(
    state: inout GameState,
    action: Action,
    dependencies: StateHolder
) throws -> Effect {
    let state = state
    return .run {
        await verifyState(state: state, action: action, prevState: dependencies)
    }
}

private struct GameStoreDependencies {
    let stateHolder: StateHolder
}

private func verifyState(
    state: GameState,
    action: Action,
    prevState: StateHolder
) async -> Action? {
    var nextState = prevState.value
    _ = try? gameReducer(state: &nextState, action: action, dependencies: ())

    assert(nextState == state, "Inconsistent state after applying \(action)")

    prevState.value = nextState
    return nil
}

private class StateHolder: @unchecked Sendable {
    var value: GameState

    init(value: GameState) {
        self.value = value
    }
}
