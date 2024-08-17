//
//  StagecoachTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class StagecoachTests: XCTestCase {
    func test_plaStagecoach_shouldDraw2Cards() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.stagecoach])
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.preparePlay(.stagecoach, player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .preparePlay(.stagecoach, player: "p1"),
            .discardPlayed(.stagecoach, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
