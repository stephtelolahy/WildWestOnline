//
//  StealTest.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 04/11/2024.
//

import Testing
import Bang

struct StealTest {
    @Test func test_drawHand_shouldRemoveCardFromTargetHand() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withHand(["c21", "c22"])
            }
            .build()

        // When
        let action = GameAction.steal("c21", target: "p2", player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.players.get("p1").hand == ["c21"])
        #expect(result.players.get("p2").hand == ["c22"])
    }

    @Test func test_drawInPlay_shouldRemoveCardFromTargetInPlay() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withInPlay(["c21", "c22"])
            }
            .build()

        // When
        let action = GameAction.steal("c21", target: "p2", player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.players.get("p1").hand == ["c21"])
        #expect(result.players.get("p2").inPlay == ["c22"])
    }
}
