//
//  IncreaseMagnifyingTest.swift
//
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import Testing
import Bang

struct IncreaseMagnifyingTest {
    @Test func increseMagnifying_shouldUpdatePlayerAttribute() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withMagnifying(0)
            }
            .build()
        
        // When
        let action = GameAction.increaseMagnifying(1, player: "p1")
        let result = try GameReducer().reduce(state, action)
        
        // Then
        #expect(result.players.get("p1").magnifying == 1)
    }
}
