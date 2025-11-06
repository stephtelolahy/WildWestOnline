//
//  SaloonTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

import Testing
import GameFeature

struct SaloonTest {
    @Test func play_withSelfDamaged_shouldHealOneLifePoint() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.saloon])
                    .withHealth(3)
                    .withMaxHealth(4)
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.saloon, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .play(.saloon, player: "p1"),
            .heal(1, player: "p1")
        ])
    }

    @Test func play_withSomePlayersDamaged_shouldHealOneLifePoint() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.saloon])
                    .withHealth(4)
                    .withMaxHealth(4)
            }
            .withPlayer("p2") {
                $0.withHealth(2)
                    .withMaxHealth(4)
            }
            .withPlayer("p3") {
                $0.withHealth(3)
                    .withMaxHealth(4)
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.saloon, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .play(.saloon, player: "p1"),
            .heal(1, player: "p2"),
            .heal(1, player: "p3")
        ])
    }

    @Test func play_withNoPlayerDamaged_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.saloon])
                    .withHealth(4)
                    .withMaxHealth(4)
            }
            .withPlayer("p2") {
                $0.withHealth(3)
                    .withMaxHealth(3)
            }
            .build()

        // When
        // Then
        let action = GameFeature.Action.preparePlay(.saloon, player: "p1")
        await #expect(throws: GameFeature.Error.noReq(.woundedPlayers)) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
