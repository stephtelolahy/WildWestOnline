//
//  PunchTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/11/2025.
//

import Testing
import GameFeature

struct PunchTest {
    @Test func play_shouldShootAtRange1() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.punch])
                    .withWeapon(1)
            }
            .withPlayer("p2") {
                $0.withRemoteness(1)
            }
            .withPlayer("p3")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.punch, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.punch, player: "p1"),
            .choose("p3", player: "p1"),
            .play(.punch, player: "p1", target: "p3"),
            .shoot("p3"),
            .damage(1, player: "p3")
        ])
    }
}
