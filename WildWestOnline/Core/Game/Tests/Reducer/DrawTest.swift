//
//  DrawTest.swift
//  BangTests
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import GameCore
import Combine

struct DrawTest {
    @Test func draw_shouldMoveCardFromDeckToDiscard() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withDeck(["c2", "c3"])
            .withDiscard(["c1"])
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.draw(player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.discard == ["c2", "c1"])
        await #expect(sut.state.deck == ["c3"])
    }

    @Test func draw_withEmptyDeck_withEnoughDiscard_shouldResetDeck() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withDiscard(["c1", "c2", "c3"])
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.draw(player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.discard == ["c2", "c1"])
        await #expect(sut.state.deck == ["c3"])
    }

    @Test func draw_withEmptyDeck_withoutEnoughDiscard_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilder()
            .build()
        let sut = await createGameStore(initialState: state)

        var receivedErrors: [Error] = []
        var cancellables: Set<AnyCancellable> = []
        await MainActor.run {
            sut.errorPublisher
                .sink { receivedErrors.append($0) }
                .store(in: &cancellables)
        }

        // When
        let action = GameAction.draw(player: "p1")
        await sut.dispatch(action)

        // Then
        #expect(receivedErrors as? [GameError] == [
            .insufficientDeck
        ])
    }
}
