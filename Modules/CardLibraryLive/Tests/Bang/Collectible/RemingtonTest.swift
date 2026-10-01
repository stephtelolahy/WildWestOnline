//
//  RemingtonTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct RemingtonTest {
    @Test func playRemington_shouldEquipAndSetWeapon() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.remington])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.remington, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.remington, player: "p1"),
            .equip(.remington, player: "p1"),
            .setWeapon(3, player: "p1")
        ])
    }
}
