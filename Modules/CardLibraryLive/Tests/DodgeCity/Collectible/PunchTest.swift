//
//  PunchTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/11/2025.
//

import Testing
import GameCore

struct PunchTest {
    @Test func play_shouldShootAtRange1() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.punch])
                    .withWeapon(1)
            }
            .withPlayer("p2") {
                $0.withRemoteness(1)
            }
            .withPlayer("p3")
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.punch, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.punch, player: "p1"),
            .choose("p3", player: "p1"),
            .play(.punch, player: "p1", target: "p3"),
            .shoot("p3"),
            .damage(1, player: "p3")
        ])
    }
}
