//
//  EliminateTests.swift
//
//
//  Created by Hugues Telolahy on 05/05/2023.
//

@testable import GameCore
import XCTest

final class EliminateTests: XCTestCase {
    func test_eliminatePlayer_shouldRemoveFromPlayOrder() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.eliminate(player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.round.playOrder, ["p2"])
    }

    func test_eliminatePlayer_shouldRemoveSequence() throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withSequence([.effect(.drawDeck, ctx: EffectContext(sourceEvent: .nothing, sourceActor: "p1", sourceCard: "c1"))])
            .build()

        // When
        let action = GameAction.eliminate(player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        XCTAssertEqual(result.sequence.queue, [])
    }
}
