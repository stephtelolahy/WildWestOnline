//
//  StagecoachTest.swift
//  BangTests
//
//  Created by Hugues Telolahy on 28/10/2024.
//

import Testing
import Bang

struct StagecoachTest {
    @Test func play_shouldDraw2Cards() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.stagecoach])
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.play(.stagecoach, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .play(.stagecoach, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
