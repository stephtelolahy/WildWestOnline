//
//  LuckyDukeTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//
import Testing
@testable import GameFeature
@testable import CardResources

struct LuckyDukeTests {
    @Test func LuckyDuke_shouldHaveTwoFlippedCards() async throws {
        // Given
        let state = GameSetup.buildGame(
            figures: [.luckyDuke],
            deck: [],
            cards: Cards.all.toDictionary,
            auras: []
        )

        // When
        let player = state.players.get(.luckyDuke)

        // Then
        #expect(player.cardsPerDraw == 2)
    }
}
