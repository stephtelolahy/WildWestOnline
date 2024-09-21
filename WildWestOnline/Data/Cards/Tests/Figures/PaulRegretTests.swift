//
//  PaulRegretTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import CardsData
import GameCore
import XCTest

final class PaulRegretTests: XCTestCase {
    func test_PaulRegret_shouldIncrementDistanceFromOthers() throws {
        // Given
        let state = Setup.buildGame(
            figures: [.paulRegret],
            deck: [],
            cards: CardsRepository().inventory.cards
        )

        // When
        let player = state.player(.paulRegret)

        // Then
        XCTAssertEqual(player.attributes[.remoteness], 1)
    }
}
