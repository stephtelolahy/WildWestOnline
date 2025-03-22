//
//  BeerTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 30/10/2024.
//

import Testing
import GameCore

struct BeerTest {
    @Test func play_beingDamaged_shouldHealOneLifePoint() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.beer])
                    .withHealth(2)
                    .withMaxHealth(3)
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameAction.preparePlay(.beer, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .play(.beer, player: "p1"),
            .heal(1, player: "p1")
        ])
    }

    @Test func play_alreadyMaxHealth_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.beer])
                    .withHealth(3)
                    .withMaxHealth(3)
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        // Then
        let action = GameAction.preparePlay(.beer, player: "p1")
        await #expect(throws: GameError.playerAlreadyMaxHealth("p1")) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }

    @Test func play_twoPlayersLeft_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.beer])
                    .withHealth(2)
                    .withMaxHealth(3)
            }
            .withPlayer("p2")
            .build()

        // When
        // Then
        let action = GameAction.preparePlay(.beer, player: "p1")
        await #expect(throws: GameError.noReq(.playersAtLeast(3))) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
