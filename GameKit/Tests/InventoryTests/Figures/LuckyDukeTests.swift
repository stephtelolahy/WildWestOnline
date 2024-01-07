//
//  LuckyDukeTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//
// swiftlint:disable no_magic_numbers

import Game
import Inventory
import XCTest

final class LuckyDukeTests: XCTestCase {
    func test_LuckyDuke_shouldHaveTwoFlippedCards() {
        // Given
        let state = Setup.buildGame(figures: [.luckyDuke], deck: [], cardRef: CardList.all)

        // When
        let player = state.player(.luckyDuke)

        // Then
        XCTAssertEqual(player.attributes[.flippedCards], 2)
    }
}
