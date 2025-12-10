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
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.beer])
                    .withHealth(2)
                    .withMaxHealth(3)
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.beer, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.beer, player: "p1"),
            .play(.beer, player: "p1"),
            .heal(1, player: "p1")
        ])
    }

    @Test func play_alreadyMaxHealth_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
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
        let action = GameFeature.Action.preparePlay(.beer, player: "p1")
        await #expect(throws: GameFeature.Error.playerAlreadyMaxHealth("p1")) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }

    @Test func play_twoPlayersLeft_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.beer])
                    .withHealth(2)
                    .withMaxHealth(3)
            }
            .withPlayer("p2")
            .build()

        // When
        // Then
        let action = GameFeature.Action.preparePlay(.beer, player: "p1")
        await #expect(throws: GameFeature.Error.noReq(.minimumPlayers(3))) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
