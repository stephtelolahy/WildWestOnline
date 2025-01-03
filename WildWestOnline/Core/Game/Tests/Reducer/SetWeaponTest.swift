//
//  SetWeaponTest.swift
//
//
//  Created by Hugues Telolahy on 30/08/2023.
//

import Testing
import GameCore

struct SetWeaponTest {
    @Test func setWeapon_shouldSetValue() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.setWeapon(3, player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.players.get("p1").weapon == 3)
    }
}
