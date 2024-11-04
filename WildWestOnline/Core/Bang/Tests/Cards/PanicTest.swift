//
//  PanicTest.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 04/11/2024.
//

import Testing
import Bang

struct PanicTest {
    @Test func test_playing_Panic_noPlayerAllowed_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .build()

        // When
        // Then
        let action = GameAction.play(.panic, player: "p1")
        await #expect(throws: GameError.noChoosableTarget([.atDistance(1), .havingCard])) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }

    @Test func test_playing_Panic_targetIsOther_havingHandCards_shouldChooseOneHandCard() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .withPlayer("p2") {
                $0.withHand(["c21"])
            }
            .build()

        // When
        let action = GameAction.play(.panic, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2"], selectionIndex: 0),
            .init(options: ["hiddenHand-0"], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .play(.panic, player: "p1"),
            .choose("p2", player: "p1"),
            .choose("hiddenHand-0", player: "p1"),
            .steal("c21", target: "p2", player: "p1")
        ])
    }
    /*
    @Test func test_playing_Panic_targetIsOther_havingInPlayCards_shouldChooseInPlayCard() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .withPlayer("p2") {
                $0.withInPlay(["c21", "c22"])
            }
            .build()

        // When
        let action = GameAction.play(.panic, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2", "c22"])

        // Then
        XCTAssertEqual(result, [
            .playBrown(.panic, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .chooseOne(.cardToSteal, options: ["c21", "c22"], player: "p1"),
            .stealInPlay("c22", target: "p2", player: "p1")
        ])
    }

    @Test func test_playing_Panic_targetIsOther_havingHandAndInPlayCards_shouldChooseAnyCard() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .withPlayer("p2") {
                $0.withHand(["c21"])
                    .withInPlay(["c22", "c23"])
            }
            .build()

        // When
        let action = GameAction.play(.panic, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2", "c23"])

        // Then
        XCTAssertEqual(result, [
            .playBrown(.panic, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .chooseOne(.cardToSteal, options: ["c22", "c23", "hiddenHand-0"], player: "p1"),
            .stealInPlay("c23", target: "p2", player: "p1")
        ])
    }
 */
}
