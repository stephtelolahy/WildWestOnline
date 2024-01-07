//
//  PaulRegretTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Game
import Inventory
import XCTest

final class PaulRegretTests: XCTestCase {
    func test_PaulRegret_shouldHaveMustang() {
        // Given
        let state = Setup.buildGame(figures: [.paulRegret], deck: [], cardRef: CardList.all)

        // When
        let player = state.player(.paulRegret)

        // Then
        XCTAssertEqual(player.attributes[.mustang], 1)
    }
}
