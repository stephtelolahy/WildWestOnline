//
//  StealTest.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 04/11/2024.
//

import Testing
import GameCore

struct StealTest {
    @Test func steal_shouldRemoveCardFromTargetHand() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withHand(["c21", "c22"])
            }
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.stealHand("c21", target: "p2", player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.players.get("p1").hand == ["c21"])
        await #expect(sut.state.players.get("p2").hand == ["c22"])
    }

    @Test func steal_shouldRemoveCardFromTargetInPlay() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withInPlay(["c21", "c22"])
            }
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.stealInPlay("c21", target: "p2", player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.players.get("p1").hand == ["c21"])
        await #expect(sut.state.players.get("p2").inPlay == ["c22"])
    }
}
