//
//  SchofieldTest.swift
//
//
//  Created by Hugues Telolahy on 17/07/2023.
//

import Testing
import GameFeature

struct SchofieldTest {
    @Test func play_shouldSetWeapon() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.schofield])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.schofield, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .equip(.schofield, player: "p1"),
            .setWeapon(2, player: "p1")
        ])
    }

    @Test func discardFromInPlay_shouldResetToDefaultWeapon() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.schofield])
                    .withWeapon(2)
            }
            .build()

        // When
        let action = GameFeature.Action.discardInPlay(.schofield, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .discardInPlay(.schofield, player: "p1"),
            .setWeapon(1, player: "p1")
        ])
    }

    @Test func stealFromInPlay_shouldResetToDefaultWeapon() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.schofield])
                    .withWeapon(2)
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameFeature.Action.stealInPlay(.schofield, target: "p1", player: "p2")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            action,
            .setWeapon(1, player: "p1")
        ])
    }
}
