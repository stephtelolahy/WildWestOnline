//
//  PaulRegretTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import CardsRepository
import GameCore
import XCTest

final class PaulRegretTests: XCTestCase {
    func test_PaulRegret_shouldIncrementDistanceFromOthers() {
        // Given
        let state = Setup.buildGame(figures: [.paulRegret], deck: [], cardRef: CardList.all)

        // When
        let player = state.player(.paulRegret)

        // Then
        XCTAssertEqual(player.attributes[.remoteness], 1)
    }
}
