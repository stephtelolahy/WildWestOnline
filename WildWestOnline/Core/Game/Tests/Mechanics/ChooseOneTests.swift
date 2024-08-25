//
//  ChooseOneTests.swift
//  
//
//  Created by Hugues Telolahy on 06/01/2024.
//

@testable import GameCore
import XCTest

final class ChooseOneTests: XCTestCase {
    func test_dispatchAction_waited_shouldRemoveWaitingState() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2", "c3"])
            }
            .withChooseOne(.cardToDraw, options: ["c1", "c2"], player: "p1")
            .withSequence([.prepareEffect(.matchAction([:]), ctx: .init(sourceEvent: .draw, sourceActor: "p1", sourceCard: "c0"))])
            .build()

        // When
        let action = GameAction.prepareChoose("c1", player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.sequence.chooseOne, [:])
    }

    func test_dispatchAction_nonWaited_shouldThrowError() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2", "c3"])
            }
            .withChooseOne(.cardToDraw, options: ["c1", "c2"], player: "p1")
            .build()

        // When
        // Then
        let action = GameAction.prepareChoose("c3", player: "p1")
        XCTAssertThrowsError(try GameState.reducer(state, action)) { error in
            XCTAssertEqual(error as? SequenceState.Error, .unwaitedAction)
        }
    }
}
