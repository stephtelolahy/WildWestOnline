//
//  PaulRegretTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore
@testable import CardLibraryLive

struct PaulRegretTest {
    @Test func shouldIncrementDistanceFromOthers() async throws {
        // Given
        let state = GameSetup.buildGame(
            figures: [.paulRegret],
            deck: [],
            cards: Cards.all.toDictionary,
            auras: []
        )

        // When
        let player = state.players.get(.paulRegret)

        // Then
        #expect(player.remoteness == 1)
    }
}
