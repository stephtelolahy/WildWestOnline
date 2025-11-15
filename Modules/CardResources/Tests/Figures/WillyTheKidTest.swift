//
//  WillyTheKidTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameFeature
@testable import CardResources

struct WillyTheKidTest {
    @Test func willyTheKid_shouldSetNoLimitForBangPerTurn() async throws {
        // Given
        let state = GameSetup.buildGame(
            figures: [.willyTheKid],
            deck: [],
            cards: Cards.all.toDictionary,
            playerAbilities: []
        )

        // When
        let player = state.players.get(.willyTheKid)

        // Then
        #expect(player.playLimitsPerTurn[.bang] == .unlimited)
    }
}
