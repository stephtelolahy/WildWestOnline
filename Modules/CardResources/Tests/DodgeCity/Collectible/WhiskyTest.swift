//
//  WhiskyTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/11/2025.
//

import Testing
import GameFeature

struct WhiskyTest {
    @Test func play_shouldHeal2() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand(["c1", .whisky])
                    .withHealth(1)
                    .withMaxHealth(4)
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.whisky, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.whisky, player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .play(.whisky, player: "p1", target: "p1"),
            .heal(2, player: "p1")
        ])
    }

    @Test func play_withoutCostCard_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.whisky])
                    .withHealth(1)
                    .withMaxHealth(4)
            }
            .build()

        // When
        // Assert
        let action = GameFeature.Action.preparePlay(.whisky, player: "p1")
        await #expect(throws: GameFeature.Error.noChoosableCard([.isFromHand], player: "p1")) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
