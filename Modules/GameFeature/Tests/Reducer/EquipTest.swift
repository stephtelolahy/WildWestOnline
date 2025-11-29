//
//  EquipTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameFeature

struct EquipTest {
    @Test func equip_shouldPutCardInPlay() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .build()

        // When
        let action = GameFeature.Action.equip("c1", player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").hand == ["c2"])
        #expect(result.players.get("p1").inPlay == ["c1"])
        #expect(result.discard.isEmpty)
    }

    @Test func equip_withCardAlreadyInPlay_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c-1"])
                    .withInPlay(["c-2"])
            }
            .build()

        // When
        // Then
        let action = GameFeature.Action.equip("c-1", player: "p1")
        await #expect(throws: GameFeature.Error.cardAlreadyInPlay("c")) {
            try await dispatch(action, state: state)
        }
    }
}
