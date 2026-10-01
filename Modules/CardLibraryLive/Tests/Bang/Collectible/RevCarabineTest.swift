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
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.revCarabine])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.revCarabine, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.revCarabine, player: "p1"),
            .equip(.revCarabine, player: "p1"),
            .setWeapon(4, player: "p1")
        ])
    }
}
