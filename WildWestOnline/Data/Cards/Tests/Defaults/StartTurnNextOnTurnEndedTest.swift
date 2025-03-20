//
//  StartTurnNextOnTurnEndedTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct StartTurnNextOnTurnEndedTest {
    @Test func endturn_shouldStartNextTurn() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([
                    .defaultEndTurn,
                    .defaultStartTurnNextOnTurnEnded
                ])
            }
            .withPlayer("p2")
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.preparePlay(.defaultEndTurn, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.defaultEndTurn, player: "p1"),
            .endTurn(player: "p1"),
            .startTurn(player: "p2")
        ])
    }
}
