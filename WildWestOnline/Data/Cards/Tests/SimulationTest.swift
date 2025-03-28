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
import Combine

struct SimulationTest {
    @Test func simulate2PlayersGame_shouldComplete() async throws {
        try await simulateGame(playersCount: 3)
    }

    private func simulateGame(playersCount: Int) async throws {
        // Given
        let deck = GameSetup.buildDeck(cardSets: CardSets.bang).shuffled()
        let figures = Array(Figures.bang.shuffled().prefix(playersCount))
        var state = GameSetup.buildGame(figures: figures, deck: deck, cards: Cards.all, defaultAbilities: DefaultAbilities.all)
        for player in state.playOrder {
            state.playMode[player] = .auto
        }

        let store = await createGameStoreWithAIAgent(initialState: state)

        let stateVerifier = StateVerifier(initialState: state)
        var cancellables: Set<AnyCancellable> = []
        await MainActor.run {
            store.eventPublisher
                .sink { stateVerifier.receiveAction(action: $0) }
                .store(in: &cancellables)
            store.$state
                .sink { stateVerifier.receiveState(state: $0) }
                .store(in: &cancellables)
        }

        // When
        let startAction = GameFeature.Action.startTurn(player: state.playOrder[0])
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
                    try loggerReducer(state: &state, action: action, dependencies: ()),
                    try gameReducer(state: &state, action: action, dependencies: ()),
                    try updateGameReducer(state: &state, action: action, dependencies: ()),
                    try playAIMoveReducer(state: &state, action: action, dependencies: ())
                ])
        },
        dependencies: ()
    )
}

private class StateVerifier {
    var prevState: GameState
    var currentState: GameState

    init(initialState: GameState) {
        self.prevState = initialState
        self.currentState = initialState
    }

    func receiveState(state: GameState) {
        prevState = currentState
        currentState = state
    }

    func receiveAction(action: ActionProtocol) {
        var nextState = prevState
        _ = try? gameReducer(state: &nextState, action: action, dependencies: ())
        assert(nextState == currentState, "Inconsistent state after applying \(action)")
    }
}
