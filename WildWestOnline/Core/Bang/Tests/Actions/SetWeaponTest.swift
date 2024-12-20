//
//  SetWeaponTest.swift
//
//
//  Created by Hugues Telolahy on 30/08/2023.
//

import Testing
import Bang

struct SetWeaponTest {
    @Test func setWeapon_shouldSetValue() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .build()

        // When
        let action = GameAction.setWeapon(3, player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.players.get("p1").weapon == 3)
    }
}
