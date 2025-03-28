//
//  WinchesterTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct WinchesterTest {
    @Test func playWinchester_shouldEquipAndSetAttribute() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.winchester])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.winchester, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .equip(.winchester, player: "p1"),
            .setWeapon(5, player: "p1")
        ])
    }
}
