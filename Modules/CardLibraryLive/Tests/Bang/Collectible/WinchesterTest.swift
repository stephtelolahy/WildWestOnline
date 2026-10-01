//
//  WinchesterTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct WinchesterTest {
    @Test func playWinchester_shouldEquipAndSetWeapon() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.winchester])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.winchester, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.winchester, player: "p1"),
            .equip(.winchester, player: "p1"),
            .setWeapon(5, player: "p1")
        ])
    }
}
