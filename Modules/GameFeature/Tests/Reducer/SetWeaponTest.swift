//
//  SetWeaponTest.swift
//
//
//  Created by Hugues Telolahy on 30/08/2023.
//

import Testing
@testable import GameFeature

struct SetWeaponTest {
    @Test func setWeapon_shouldSetValue() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .build()

        // When
        let action = GameFeature.Action.setWeapon(3, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").weapon == 3)
    }
}
