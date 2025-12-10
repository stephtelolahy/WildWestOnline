//
//  BangTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct BangTest {
    @Test func play_shouldDeal1Damage() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.bang, player: "p1"),
            .choose("p2", player: "p1"),
            .play(.bang, player: "p1", target: "p2"),
            .shoot("p2"),
            .damage(1, player: "p2")
        ])
    }

    @Test func play_reachedLimitPerTurn_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang2])
                    .withWeapon(1)
            }
            .withPlayer("p2")
            .withEvents([
                .equip(.barrel, player: "p1"),
                .play(.bang1, player: "p1"),
                .startTurn(player: "p1"),
            ])
            .build()

        // When
        // Assert
        let action = GameFeature.Action.preparePlay(.bang, player: "p1")
        await #expect(throws: GameFeature.Error.noReq(.playLimitThisTurn(1))) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }

    @Test func play_noPlayerReachable_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2") {
                $0.withRemoteness(1)
            }
            .build()

        // When
        // Then
        let action = GameFeature.Action.preparePlay(.bang, player: "p1")
        await #expect(throws: GameFeature.Error.noChoosableTarget([.reachable])) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
