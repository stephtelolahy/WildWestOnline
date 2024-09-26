//
//  PlayEquipmentTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 22/09/2024.
//

import Testing
import GameCore

struct PlayEquipmentTest {
    @Test func playEquipment_withCardNotInPlay_shouldPutCardInPlay() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .build()

        // When
        let action = GameAction.playEquipment("c1", player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.player("p1").hand == ["c2"])
        #expect(result.player("p1").inPlay == ["c1"])
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
        let action = GameAction.playEquipment("c-1", player: "p1")
        #expect(throws: GameState.Error.cardAlreadyInPlay("c")) {
            try GameState.reducer(state, action)
        }
    }
}
