//
//  DrawDeckTest.swift
//  BangTest
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import GameCore
import Combine

struct DrawDeckTest {
    @Test func drawDeck_whithNonEmptyDeck_shouldRemoveTopCard() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withDeck(["c1", "c2"])
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.drawDeck(player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.players.get("p1").hand == ["c1"])
        await #expect(sut.state.deck == ["c2"])
    }

    @Test func drawDeck_whitEmptyDeckAndEnoughDiscardPile_shouldResetDeck() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withDiscard(["c1", "c2", "c3", "c4"])
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.drawDeck(player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.deck == ["c3", "c4"])
        await #expect(sut.state.discard == ["c1"])
        await #expect(sut.state.players.get("p1").hand == ["c2"])
    }

    @Test func drawDeck_whitEmptyDeckAndNotEnoughDiscardPile_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
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
        let action = GameAction.drawDeck(player: "p1")
        await sut.dispatch(action)

        // Then
        #expect(receivedErrors as? [GameError] == [
            .insufficientDeck
        ])
    }
}
