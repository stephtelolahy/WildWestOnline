//
//  RoseDoolanTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import CardsRepository
import GameCore
import XCTest

final class RoseDoolanTests: XCTestCase {
    func test_RoseDoolan_shouldDecrementDistanceToOthers() {
        // Given
        let state = Setup.buildGame(figures: [.roseDoolan], deck: [], cardRef: CardList.all)

        // When
        let player = state.player(.roseDoolan)

        // Then
        XCTAssertEqual(player.attributes[.magnifying], 1)
    }
}
