//
//  PaulRegretTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore
import GameData

struct PaulRegretTest {
    @Test func paulRegret_shouldIncrementDistanceFromOthers() async throws {
        // Given
        let state = GameSetupService.buildGame(
            figures: [.paulRegret],
            deck: [],
            cards: Cards.all.toDictionary,
            playerAbilities: []
        )

        // When
        let player = state.players.get(.paulRegret)

        // Then
        #expect(player.remoteness == 1)
    }
}
