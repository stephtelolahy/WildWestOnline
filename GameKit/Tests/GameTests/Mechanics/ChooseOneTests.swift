//
//  ChooseOneTests.swift
//  
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import Game
import XCTest

final class ChooseOneTests: XCTestCase {
    func test_dispatchAction_waited_shouldRemoveWaitingState() {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2", "c3"])
            }
            .withChooseOne("p1", options: [
                "c1": .discardHand("c1", player: "p1"),
                "c2": .discardHand("c2", player: "p1")
            ])
            .build()

        // When
        let action = GameAction.discardHand("c1", player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.chooseOne, [:])
    }

    func test_dispatchAction_nonWaited_shouldThrowError() {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2", "c3"])
            }
            .withChooseOne("p1", options: [
                "c1": .discardHand("c1", player: "p1"),
                "c2": .discardHand("c2", player: "p1")
            ])
            .build()

        // When
        let action = GameAction.discardHand("c3", player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertFalse(result.chooseOne.isEmpty)
        XCTAssertEqual(result.error, .unwaitedAction)
    }
}
