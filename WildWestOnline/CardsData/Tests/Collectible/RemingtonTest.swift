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
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.remington])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.remington, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .equip(.remington, player: "p1"),
            .setWeapon(3, player: "p1")
        ])
    }
}
