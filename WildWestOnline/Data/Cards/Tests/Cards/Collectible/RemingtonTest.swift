//
//  RemingtonTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import Bang

struct RemingtonTest {
    @Test func playRemington_shouldEquipAndSetWeapon() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.remington])
            }
            .build()

        // When
        let action = GameAction.play(.remington, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .play(.remington, player: "p1"),
            .equip(.remington, player: "p1"),
            .setWeapon(3, player: "p1")
        ])
    }
}
