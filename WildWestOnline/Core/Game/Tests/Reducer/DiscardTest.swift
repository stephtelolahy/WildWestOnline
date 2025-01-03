//
//  DiscardTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

import Testing
import GameCore

struct DiscardTest {
    @Test func discard_shouldRemoveCardFromHand() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.discardHand("c1", player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.players.get("p1").hand == ["c2"])
        await #expect(sut.state.discard == ["c1"])
    }

    @Test func discard_shouldRemoveCardFromInPlay() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withInPlay(["c1", "c2"])
            }
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.discardInPlay("c1", player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.players.get("p1").inPlay == ["c2"])
        await #expect(sut.state.discard == ["c1"])
    }
}
