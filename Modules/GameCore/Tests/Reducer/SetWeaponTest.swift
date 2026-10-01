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
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .build()

        let result = try await dispatch(.setWeapon(3, player: "p1"), state: state)

        #expect(result.players.get("p1").weapon == 3)
    }
}
