//
//  PaulRegretTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import CardsData
import GameCore
import Testing

struct PaulRegretTests {
    @Test func PaulRegret_shouldIncrementDistanceFromOthers() async throws {
        // Given
        let state = Setup.buildGame(
            figures: [.paulRegret],
            deck: [],
            cards: CardsRepository().inventory.cards
        )

        // When
        let player = state.player(.paulRegret)

        // Then
        #expect(player.remoteness == 1)
    }
}
