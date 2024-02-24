//
//  RoseDoolanTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import CardsRepository
import XCTest

final class RoseDoolanTests: XCTestCase {
    func test_RoseDoolan_shouldHaveScope() {
        // Given
        let state = Setup.buildGame(figures: [.roseDoolan], deck: [], cardRef: CardList.all)

        // When
        let player = state.player(.roseDoolan)

        // Then
        XCTAssertEqual(player.attributes[.scope], 1)
    }
}
