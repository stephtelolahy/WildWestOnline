//
//  RevCarabineTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameFeature

struct RevCarabineTest {
    @Test func playRevCarabine_shouldEquipAndSetWeapon() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.revCarabine])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.revCarabine, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.revCarabine, player: "p1"),
            .equip(.revCarabine, player: "p1"),
            .setWeapon(4, player: "p1")
        ])
    }
}
