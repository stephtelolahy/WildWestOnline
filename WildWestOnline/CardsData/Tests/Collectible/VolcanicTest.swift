//
//  VolcanicTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//
import Testing
import GameCore

struct VolcanicTest {
    @Test func playVolcanic_withoutWeaponInPlay_shouldSetUnlimitedBangsPerTurn() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.volcanic])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.volcanic, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .equip(.volcanic, player: "p1"),
            .setWeapon(1, player: "p1"),
            .setPlayLimitPerTurn([.bang: .unlimited], player: "p1")
        ])
    }
}
