//
//  HideoutTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameFeature

struct HideoutTests {
    @Test func play_shouldEquipAndIncreaseRemoteness() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.hideout])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.hideout, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.hideout, player: "p1"),
            .equip(.hideout, player: "p1"),
            .increaseRemoteness(1, player: "p1")
        ])
    }

    @Test func discard_shouldDecreaseRemoteness() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.hideout])
                    .withRemoteness(1)
            }
            .build()

        // When
        let action = GameFeature.Action.discardInPlay(.hideout, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .discardInPlay(.hideout, player: "p1"),
            .increaseRemoteness(-1, player: "p1")
        ])
    }
}
