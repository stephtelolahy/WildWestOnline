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
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2")
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.bang, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.bang, player: "p1"),
            .choose("p2", player: "p1"),
            .play(.bang, player: "p1", target: "p2"),
            .shoot("p2"),
            .damage(1, player: "p2")
        ])
    }

    @Test func play_reachedLimitPerTurn_shouldThrowError() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
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

        // Assert
        await #expect(throws: GameFeature.Error.noReq(.playLimit(1))) {
            try await dispatchUntilCompleted(.preparePlay(.bang, player: "p1"), state: state)
        }
    }

    @Test func play_noPlayerReachable_shouldThrowError() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2") {
                $0.withRemoteness(1)
            }
            .build()

        await #expect(throws: GameFeature.Error.noChoosableTarget([.reachable])) {
            try await dispatchUntilCompleted(.preparePlay(.bang, player: "p1"), state: state)
        }
    }
}
