//
//  StagecoachTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct StagecoachTests {
    @Test func plaStagecoach_shouldDraw2Cards() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.stagecoach])
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.preparePlay(.stagecoach, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .playBrown(.stagecoach, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
