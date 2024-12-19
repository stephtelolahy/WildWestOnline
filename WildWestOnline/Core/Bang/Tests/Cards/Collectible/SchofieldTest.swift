//
//  SchofieldTest.swift
//
//
//  Created by Hugues Telolahy on 17/07/2023.
//

import Testing
import Bang

struct SchofieldTest {
    @Test func playSchofield_shouldSetWeapon() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.schofield])
                    .withWeapon(1)
            }
            .build()

        // When
        let action = GameAction.play(.schofield, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .play(.schofield, player: "p1"),
            .equip(.schofield, player: "p1"),
            .setWeapon(2, player: "p1")
        ])
    }

    @Test func discardSchofieldFromInPlay_shouldResetToDefaultWeapon() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.schofield])
                    .withWeapon(2)
            }
            .build()

        // When
        let action = GameAction.discardInPlay(.schofield, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .discardInPlay(.schofield, player: "p1"),
            .setWeapon(1, player: "p1")
        ])
    }

    @Test func playSchofield_withAnotherWeaponInPlay_shouldDiscardPreviousWeapon() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.schofield])
                    .withInPlay([.remington])
                    .withWeapon(3)
            }
            .build()

        // When
        let action = GameAction.play(.schofield, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .play(.schofield, player: "p1"),
            .discardInPlay(.remington, player: "p1"),
            .setWeapon(1, player: "p1"),
            .equip(.schofield, player: "p1"),
            .setWeapon(2, player: "p1")
        ])
    }
}
