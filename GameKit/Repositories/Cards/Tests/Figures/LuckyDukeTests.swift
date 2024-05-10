//
//  LuckyDukeTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import CardsRepository
import GameCore
import XCTest

final class LuckyDukeTests: XCTestCase {
    func test_LuckyDuke_shouldHaveTwoFlippedCards() {
        // Given
        let state = Setup.buildGame(figures: [.luckyDuke], deck: [], cards: CardList.all)

        // When
        let player = state.player(.luckyDuke)

        // Then
        XCTAssertEqual(player.attributes[.flippedCards], 2)
    }
}
