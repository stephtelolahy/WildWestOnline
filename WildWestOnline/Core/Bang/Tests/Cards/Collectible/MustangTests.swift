//
//  MustangTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import Bang

struct MustangTests {
    @Test func playMustang_shouldEquipAndSetAttribute() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.mustang])
            }
            .build()

        // When
        let action = GameAction.play(.mustang, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .play(.mustang, player: "p1"),
            .equip(.mustang, player: "p1"),
            .increaseRemoteness(1, player: "p1")
        ])
    }
}
