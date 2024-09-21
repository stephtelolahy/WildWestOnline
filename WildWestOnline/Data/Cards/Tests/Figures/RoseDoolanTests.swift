//
//  RoseDoolanTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import CardsData
import GameCore
import XCTest

final class RoseDoolanTests: XCTestCase {
    func test_RoseDoolan_shouldDecrementDistanceToOthers() throws {
        // Given
        let state = Setup.buildGame(
            figures: [.roseDoolan],
            deck: [],
            cards: CardsRepository().inventory.cards
        )

        // When
        let player = state.player(.roseDoolan)

        // Then
        XCTAssertEqual(player.attributes[.magnifying], 1)
    }
}
