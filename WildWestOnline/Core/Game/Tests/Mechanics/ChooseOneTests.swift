//
//  ChooseOneTests.swift
//  
//
//  Created by Hugues Telolahy on 06/01/2024.
//

@testable import GameCore
import XCTest

final class ChooseOneTests: XCTestCase {
    func test_dispatchAction_waited_shouldRemoveWaitingState() {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2", "c3"])
            }
            .withChooseOne(.cardToDraw, options: ["c1", "c2"], player: "p1")
            .withSequence([.effect(.matchAction([:]), ctx: .init(sourceEvent: .draw, sourceActor: "p1", sourceCard: "c0"))])
            .build()

        // When
        let action = GameAction.choose("c1", player: "p1")
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
            .withChooseOne(.cardToDraw, options: ["c1", "c2"], player: "p1")
            .build()

        // When
        let action = GameAction.choose("c3", player: "p1")
        let result = GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.error, .unwaitedAction)
        XCTAssertNotNil(result.chooseOne["p1"])
    }
}