//
//  WhiskyTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/11/2025.
//

import Testing
import GameCore

struct WhiskyTest {
    @Test func play_shouldHeal2() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand(["c1", .whisky])
                    .withHealth(1)
                    .withMaxHealth(4)
            }
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.whisky, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.whisky, player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .play(.whisky, player: "p1", target: "p1"),
            .heal(2, player: "p1")
        ])
    }

    @Test func play_withoutCostCard_shouldThrowError() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.whisky])
                    .withHealth(1)
                    .withMaxHealth(4)
            }
            .build()

        // Assert
        await #expect(throws: GameFeature.Error.noChoosableCard([.inHand], player: "p1")) {
            try await dispatchUntilCompleted(.preparePlay(.whisky, player: "p1"), state: state)
        }
    }
}
