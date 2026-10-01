//
//  DrawTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 27/10/2024.
//

import Testing
import GameCore

struct DrawTest {
    @Test func draw_shouldMoveCardFromDeckToDiscard() async throws {
        let state = GameFeature.State.makeBuilder()
            .withDeck(["c2", "c3"])
            .withDiscard(["c1"])
            .build()

        let result = try await dispatch(.draw(player: "p1"), state: state)

        #expect(result.discard == ["c2", "c1"])
        #expect(result.deck == ["c3"])
    }

    @Test func draw_withEmptyDeck_shouldResetDeck() async throws {
        let state = GameFeature.State.makeBuilder()
            .withDiscard(["c1", "c2", "c3"])
            .build()

        let result = try await dispatch(.draw(player: "p1"), state: state)

        #expect(result.discard == ["c2", "c1"])
        #expect(result.deck == ["c3"])
    }

    @Test func draw_withEmptyDeck_withoutEnoughDiscard_shouldThrowError() async throws {
        let state = GameFeature.State.makeBuilder()
            .build()

        await #expect(throws: GameFeature.Error.insufficientDeck) {
            try await dispatch(.draw(player: "p1"), state: state)
        }
    }
}
