//
//  HandicapTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore
import Combine

struct HandicapTest {
    @Test func handicap_withCardNotInPlay_shouldPutcardInTargetInPlay() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.handicap("c1", target: "p2", player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").hand == ["c2"])
        #expect(result.players.get("p2").inPlay == ["c1"])
        #expect(result.players.get("p1").inPlay.isEmpty)
        #expect(result.discard.isEmpty)
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
        let action = GameAction.handicap("c-1", target: "p2", player: "p1")
        await #expect(throws: GameError.cardAlreadyInPlay("c")) {
            try await dispatch(action, state: state)
        }
    }
}
