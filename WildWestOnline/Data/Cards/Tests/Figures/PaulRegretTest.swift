//
//  PaulRegretTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore
import CardsData

struct PaulRegretTest {
    @Test func paulRegret_shouldIncrementDistanceFromOthers() async throws {
        // Given
        let state = Setup.buildGame(
            figures: [.paulRegret],
            deck: [],
            cards: Cards.all,
            defaultAbilities: []
        )

        // When
        let player = state.players.get(.paulRegret)

        // Then
        #expect(player.remoteness == 1)
    }
}
