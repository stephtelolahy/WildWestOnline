//
//  LuckyDukeTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import CardsData
import GameCore
import XCTest

final class LuckyDukeTests: XCTestCase {
    func test_LuckyDuke_shouldHaveTwoFlippedCards() throws {
        // Given
        let state = Setup.buildGame(figures: [.luckyDuke], deck: [], cards: Cards.all)

        // When
        let player = state.player(.luckyDuke)

        // Then
        #expect(player.attributes[.flippedCards] == 2)
    }
}
