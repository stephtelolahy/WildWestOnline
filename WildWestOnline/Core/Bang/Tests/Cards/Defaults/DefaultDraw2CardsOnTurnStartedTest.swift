//
//  DefaultDraw2CardsOnTurnStartedTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import Bang

struct DefaultDraw2CardsOnTurnStartedTest {
    @Test func startTurn_with2StartTurnCards_shouldDraw2Cards() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withDefaultAbilities()
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.startTurn(player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
