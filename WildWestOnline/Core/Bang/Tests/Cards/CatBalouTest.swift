//
//  CatBalouTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

import Testing
import Bang

struct CatBalouTest {
    @Test func playingCatBalou_targetIsOther_havingHandCards_shouldChooseOneHandCard() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .withPlayer("p2") {
                $0.withHand(["c21"])
            }
            .build()

        // When
        let action = GameAction.play(.catBalou, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2"], selectionIndex: 0),
            .init(options: ["hiddenHand-0"], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .play(.catBalou, player: "p1"),
            .choose("p2", player: "p1"),
            .choose("hiddenHand-0", player: "p1"),
            .discard("c21", player: "p2")
        ])
    }

    @Test func playingCatBalou_targetIsOther_havingInPlayCards_shouldChooseOneInPlayCard() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .withPlayer("p2") {
                $0.withInPlay(["c21"])
            }
            .build()

        // When
        let action = GameAction.play(.catBalou, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2"], selectionIndex: 0),
            .init(options: ["c21"], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .play(.catBalou, player: "p1"),
            .choose("p2", player: "p1"),
            .choose("c21", player: "p1"),
            .discard("c21", player: "p2")
        ])
    }

    @Test func playingCatBalou_targetIsOther_havingHandAndInPlayCards_shouldChooseAnyCard() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .withPlayer("p2") {
                $0.withHand(["c21", "c22"])
                    .withInPlay(["c23", "c24"])
            }
            .build()

        // When
        let action = GameAction.play(.catBalou, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2"], selectionIndex: 0),
            .init(options: ["hiddenHand-0", "hiddenHand-1", "c23", "c24"], selectionIndex: 2)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .play(.catBalou, player: "p1"),
            .choose("p2", player: "p1"),
            .choose("c23", player: "p1"),
            .discard("c23", player: "p2")
        ])
    }

    @Test func playingCatBalou_noPlayerHavingCards_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .withPlayer("p2")
            .build()

        // When
        // Then
        let action = GameAction.play(.catBalou, player: "p1")
        await #expect(throws: GameError.noChoosableTarget([.havingCard])) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }

    @Test func playingCatBalou_onlySelfHavingCards_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.catBalou])
                    .withInPlay(["cx"])
            }
            .withPlayer("p2")
            .build()

        // When
        // Then
        let action = GameAction.play(.catBalou, player: "p1")
        await #expect(throws: GameError.noChoosableTarget([.havingCard])) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}