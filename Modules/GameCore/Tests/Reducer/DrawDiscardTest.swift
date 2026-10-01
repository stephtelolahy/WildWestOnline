//
//  DrawDiscardTest.swift
//  BangTest
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import GameCore

struct DrawDiscardTest {
    @Test func drawDiscard_shouldRemoveTopCard() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withDiscard(["c1", "c2"])
            .build()

        let result = try await dispatch(.drawDiscard("c1", player: "p1"), state: state)

        #expect(result.players.get("p1").hand == ["c1"])
        #expect(result.discard == ["c2"])
    }

    @Test func drawDiscard_whitEmptyDiscard_shouldThrowError() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .build()

        await #expect(throws: GameFeature.Error.insufficientDiscard) {
            try await dispatch(.drawDiscard("c1", player: "p1"), state: state)
        }
    }
}
