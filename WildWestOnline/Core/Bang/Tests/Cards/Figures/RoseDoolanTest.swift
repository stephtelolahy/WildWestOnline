//
//  RoseDoolanTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import Bang

struct RoseDoolanTest {
    @Test func roseDoolan_shouldDecrementDistanceToOthers() async throws {
        // Given
        let state = Setup.buildGame(
            figures: [.roseDoolan],
            deck: [],
            cards: Cards.all,
            defaultAbilities: []
        )

        // When
        let player = state.players.get(.roseDoolan)

        // Then
        #expect(player.magnifying == 1)
    }
}
