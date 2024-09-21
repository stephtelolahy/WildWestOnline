//
//  LuckyDukeTests.swift
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
        let state = Setup.buildGame(
            figures: [.luckyDuke],
            deck: [],
            cards: CardsRepository().inventory.cards
        )

        // When
        let player = state.player(.luckyDuke)

        // Then
        XCTAssertEqual(player.attributes[.flippedCards], 2)
    }
}
