//
//  StealTest.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 04/11/2024.
//

import Testing
import Bang

struct StealTest {

    @Test func test_drawHand_shouldRemoveCardFromTargetHand() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withHand(["c21", "c22"])
            }
            .build()

        // When
        let action = GameAction.steal("c21", target: "p2", player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        XCTAssertEqual(result.field.hand["p1"], ["c21"])
        XCTAssertEqual(result.field.hand["p2"], ["c22"])
    }
    
    @Test func test_drawInPlay_shouldRemoveCardFromTargetInPlay() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2") {
                $0.withInPlay(["c21", "c22"])
            }
            .build()

        // When
        let action = GameAction.steal("c21", target: "p2", player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        XCTAssertEqual(result.field.hand["p1"], ["c21"])
        XCTAssertEqual(result.field.inPlay["p2"], ["c22"])
    }

}
