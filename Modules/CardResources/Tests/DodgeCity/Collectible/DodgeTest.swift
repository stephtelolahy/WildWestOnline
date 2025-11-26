//
//  DodgeTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/11/2025.
//

import Testing
import GameFeature

struct DodgeTest {
    @Test func beingShot_discardingDodge_shouldCounterAndDrawCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withHand([.dodge])
            }
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .shoot("p1"),
            .choose(.dodge, player: "p1"),
            .discardHand(.dodge, player: "p1"),
            .counterShoot(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
