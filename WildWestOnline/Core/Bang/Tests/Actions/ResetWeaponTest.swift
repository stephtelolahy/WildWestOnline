//
//  ResetWeaponTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 18/12/2024.
//

import Testing
import Bang

struct ResetWeaponTest {
    @Test func resetWeapon_shouldSetValueTo1() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withWeapon(3)
            }
            .build()

        // When
        let action = GameAction.resetWeapon(player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.players.get("p1").weapon == 1)
    }
}
