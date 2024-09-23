//
//  HandicapTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct PlayHandicapTests {
    @Test func handicap_withCardNotInPlay_shouldPutcardInTargetInPlay() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.playHandicap("c1", target: "p2", player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.field.hand["p1"] == ["c2"])
        #expect(result.field.inPlay["p2"] == ["c1"])
        #expect(result.field.inPlay["p1"]!.isEmpty)
        #expect(result.field.discard.isEmpty)
    }

    @Test func handicap_withCardAlreadyInPlay_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c-1"])
            }
            .withPlayer("p2") {
                $0.withInPlay(["c-2"])
            }
            .build()

        // When
        // Then
        let action = GameAction.playHandicap("c-1", target: "p2", player: "p1")
        #expect(throws: FieldState.Error.cardAlreadyInPlay("c")) {
            try GameState.reducer(state, action)
        }
    }
}
