//
//  EquipTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct EquipTest {
    @Test func equip_withCardNotInPlay_shouldPutCardInPlay() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .build()

        // When
        let action = GameAction.equip("c1", player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.players.get("p1").hand == ["c2"])
        #expect(result.players.get("p1").inPlay == ["c1"])
        #expect(result.discard.isEmpty)
    }

    @Test func equip_withCardAlreadyInPlay_shouldThrowError() async throws {
        // Given
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c-1"])
                    .withInPlay(["c-2"])
            }
            .build()

        // When
        // Then
        let action = GameAction.equip("c-1", player: "p1")
        #expect(throws: GameError.cardAlreadyInPlay("c")) {
            try GameReducer().reduce(state, action)
        }
    }
}
