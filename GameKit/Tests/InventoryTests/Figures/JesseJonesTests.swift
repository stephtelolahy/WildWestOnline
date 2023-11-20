//
//  JesseJonesTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/11/2023.
//

import Game
import Inventory
import XCTest

final class JesseJonesTests: XCTestCase {
    func test_jesseJones_shouldHaveSpecialStartTurn() throws {
        // Given
        let state = Setup.buildGame(figures: [.jesseJones], deck: [], cardRef: CardList.all)

        // When
        let player = state.player(.jesseJones)

        // Then
        XCTAssertNil(player.attributes[.drawOnSetTurn])
    }
}
