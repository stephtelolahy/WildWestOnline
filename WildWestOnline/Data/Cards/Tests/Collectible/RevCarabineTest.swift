//
//  RevCarabineTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct RevCarabineTest {
    @Test func playRevCarabine_shouldEquipAndSetWeapon() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.revCarabine])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.revCarabine, actor: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .equip(.revCarabine, player: "p1"),
            .setWeapon(4, player: "p1")
        ])
    }
}
