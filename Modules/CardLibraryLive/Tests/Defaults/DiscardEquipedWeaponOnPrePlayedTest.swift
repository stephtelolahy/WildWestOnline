//
//  DiscardEquipedWeaponOnPrePlayedTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 15/11/2025.
//

import GameCore
import Testing

struct DiscardEquipedWeaponOnPrePlayedTest {
    @Test func playSchofield_withAnotherWeaponInPlay_shouldDiscardPreviousWeapon() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withHand([.schofield])
                    .withInPlay([.remington])
                    .withWeapon(3)
            }
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.schofield, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.schofield, player: "p1"),
            .discardInPlay(.remington, player: "p1"),
            .setWeapon(1, player: "p1"),
            .equip(.schofield, player: "p1"),
            .setWeapon(2, player: "p1")
        ])
    }
}
