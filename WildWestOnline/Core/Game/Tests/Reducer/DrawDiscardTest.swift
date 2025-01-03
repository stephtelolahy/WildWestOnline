//
//  DrawDiscardTest.swift
//  BangTest
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import GameCore
import Combine

struct DrawDiscardTest {
    @Test func drawDiscard_whithNonEmptyDiscard_shouldRemoveTopCard() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withDiscard(["c1", "c2"])
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.drawDiscard(player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.players.get("p1").hand == ["c1"])
        await #expect(sut.state.discard == ["c2"])
    }

    @Test func drawDiscard_whitEmptyDiscard_shouldThrowError() async throws {
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
        let action = GameAction.drawDiscard(player: "p1")
        await sut.dispatch(action)

        // Then
        #expect(receivedErrors as? [GameError] == [
            .insufficientDiscard
        ])
    }
}
