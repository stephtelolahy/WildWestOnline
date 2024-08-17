//
//  WellsFargoTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class WellsFargoTests: XCTestCase {
    func test_playWellsFargo_shouldDraw3Cards() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.wellsFargo])
            }
            .withPlayer("p2")
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameAction.preparePlay(.wellsFargo, player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .preparePlay(.wellsFargo, player: "p1"),
            .playBrown(.wellsFargo, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
