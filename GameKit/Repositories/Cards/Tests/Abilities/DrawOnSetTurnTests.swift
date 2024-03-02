//
//  DrawOnSetTurnTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class DrawOnSetTurnTests: XCTestCase {
    func test_setTurn_with2StartTurnCards_shouldDraw2Cards() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAbilities([.drawOnSetTurn])
                    .withAttributes([.startTurnCards: 2])
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.setTurn(player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .setTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_setTurn_with3StartTurnCards_shouldDraw3Cards() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAbilities([.drawOnSetTurn])
                    .withAttributes([.startTurnCards: 3])
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.setTurn(player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .setTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
