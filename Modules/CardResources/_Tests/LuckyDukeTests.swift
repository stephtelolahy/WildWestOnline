//
//  LuckyDukeTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import CardResources
import GameFeature
import Testing

struct LuckyDukeTests {
    @Test(.disabled()) func LuckyDuke_shouldHaveTwoFlippedCards() async throws {
        // Given
        let state = Setup.buildGame(figures: [.luckyDuke], deck: [], cards: Cards.all)

        // When
        let player = state.player(.luckyDuke)

        // Then
        #expect(player.attributes[.flippedCards] == 2)
    }
}
