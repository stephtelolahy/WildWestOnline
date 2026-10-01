//
//  SpringfieldTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/11/2025.
//

import Testing
import GameCore

struct SpringfieldTest {
    @Test func play_shouldShootAtUnlimitedRange() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: ["c1", .springfield])
            .withPlayer("p2") {
                $0.withRemoteness(1)
            }
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.springfield, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.springfield, player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .choose("p2", player: "p1"),
            .play(.springfield, player: "p1", target: "p2"),
            .shoot("p2"),
            .damage(1, player: "p2")
        ])
    }

    @Test func play_withoutCostCard_shouldThrowError() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.springfield])
            .withPlayer("p2") {
                $0.withRemoteness(1)
            }
            .build()

        // Assert
        await #expect(throws: GameFeature.Error.noChoosableCard([.inHand], player: "p1")) {
            try await dispatchUntilCompleted(.preparePlay(.springfield, player: "p1"), state: state)
        }
    }
}
