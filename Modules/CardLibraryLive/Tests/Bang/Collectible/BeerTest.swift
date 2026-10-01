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
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.beer])
                    .withHealth(2)
                    .withMaxHealth(3)
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.beer, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.beer, player: "p1"),
            .play(.beer, player: "p1"),
            .heal(1, player: "p1")
        ])
    }

    @Test func play_alreadyMaxHealth_shouldThrowError() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.beer])
                    .withHealth(3)
                    .withMaxHealth(3)
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        await #expect(throws: GameFeature.Error.playerAlreadyMaxHealth("p1")) {
            try await dispatchUntilCompleted(.preparePlay(.beer, player: "p1"), state: state)
        }
    }

    @Test func play_twoPlayersLeft_shouldThrowError() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.beer])
                    .withHealth(2)
                    .withMaxHealth(3)
            }
            .withPlayer("p2")
            .build()

        await #expect(throws: GameFeature.Error.noReq(.playersAtLeast(3))) {
            try await dispatchUntilCompleted(.preparePlay(.beer, player: "p1"), state: state)
        }
    }
}
