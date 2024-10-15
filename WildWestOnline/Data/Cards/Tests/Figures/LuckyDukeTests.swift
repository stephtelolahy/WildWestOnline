//
//  LuckyDukeTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import CardsData
import GameCore
import Testing

struct LuckyDukeTests {
    @Test func LuckyDuke_shouldHaveTwoFlippedCards() async throws {
        // Given
        let state = Setup.buildGame(
            figures: [.luckyDuke],
            deck: [],
            cards: CardsRepository().inventory.cards
        )

        // When
        let player = state.player(.luckyDuke)

        // Then
        #expect(player.flippedCards == 2)
    }
}
