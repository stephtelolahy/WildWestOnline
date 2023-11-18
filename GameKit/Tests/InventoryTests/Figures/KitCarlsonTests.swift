//
//  KitCarlsonTests.swift
//  
//
//  Created by Hugues Telolahy on 18/11/2023.
//

import Game
import Inventory
import XCTest

final class KitCarlsonTests: XCTestCase {
    func test_kitCarlson_shouldHaveSpecialStartTurn() throws {
        // Given
        let state = Setup.buildGame(figures: [.kitCarlson], deck: [], cardRef: CardList.all)

        // When
        let player = state.player(.kitCarlson)

        // Then
        XCTAssertNil(player.attributes[.drawOnSetTurn])
    }

    func test_kitCarlsonStartTurn_shouldChooseDeckCards() {
    }
}
