//
//  WillyTheKidTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import CardsRepository
import XCTest

final class WillyTheKidTests: XCTestCase {
    func test_WillyTheKid_shouldHaveUnlimitedBang() {
        // Given
        let state = Setup.buildGame(figures: [.willyTheKid], deck: [], cardRef: CardList.all)

        // When
        let player = state.player(.willyTheKid)

        // Then
        XCTAssertEqual(player.attributes[.bangsPerTurn], 0)
    }
}
