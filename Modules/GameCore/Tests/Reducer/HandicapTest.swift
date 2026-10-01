//
//  HandicapTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct HandicapTest {
    @Test func handicap_shouldPutcardInTargetInPlay() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1", hand: ["c1", "c2"])
            .withPlayer("p2")
            .build()

        let result = try await dispatch(.handicap("c1", target: "p2", player: "p1"), state: state)

        #expect(result.players.get("p1").hand == ["c2"])
        #expect(result.players.get("p2").inPlay == ["c1"])
        #expect(result.players.get("p1").inPlay.isEmpty)
        #expect(result.discard.isEmpty)
    }

    @Test func handicap_withCardAlreadyInPlay_shouldThrowError() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1", hand: ["c-1"])
            .withPlayer("p2", inPlay: ["c-2"])
            .build()

        await #expect(throws: GameFeature.Error.cardAlreadyInPlay("c", player: "p2")) {
            try await dispatch(.handicap("c-1", target: "p2", player: "p1"), state: state)
        }
    }
}
