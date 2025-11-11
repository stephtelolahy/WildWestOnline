//
//  VolcanicTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//
import Testing
import GameFeature

struct VolcanicTest {
    @Test func playVolcanic_shouldSetUnlimitedBangsPerTurn() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
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
            .setPlayLimitsPerTurn([.bang: .unlimited], player: "p1")
        ])
    }

    @Test func discardVolcanicFromInPlay_shouldResetBangsPerTurn() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.volcanic])
                    .withWeapon(2)
            }
            .build()

        // When
        let action = GameFeature.Action.discardInPlay(.volcanic, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .discardInPlay(.volcanic, player: "p1"),
            .setWeapon(1, player: "p1"),
            .setPlayLimitsPerTurn([.bang: 1], player: "p1")
        ])
    }
}
