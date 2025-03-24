//
//  PanicTest.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 04/11/2024.
//

import Testing
import GameCore

struct PanicTest {
    @Test func play_targetHavingHandCards_shouldChooseOneHandCard() async throws {
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
        let action = GameAction.preparePlay(.panic, player: "p1")
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
            .stealHand("c21", target: "p2", player: "p1", source: .panic)
        ])
    }

    @Test func play_targetHavingInPlayCards_shouldChooseInPlayCard() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withDummyCards(["c21", "c22"])
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .withPlayer("p2") {
                $0.withInPlay(["c21", "c22"])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.panic, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2"], selectionIndex: 0),
            .init(options: ["c21", "c22"], selectionIndex: 1)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .play(.panic, player: "p1"),
            .choose("p2", player: "p1"),
            .choose("c22", player: "p1"),
            .stealInPlay("c22", target: "p2", player: "p1")
        ])
    }

    @Test func play_targetHavingHandAndInPlayCards_shouldChooseAnyCard() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withDummyCards(["c22", "c23"])
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .withPlayer("p2") {
                $0.withHand(["c21"])
                    .withInPlay(["c22", "c23"])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.panic, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2"], selectionIndex: 0),
            .init(options: ["c22", "c23", "hiddenHand-0"], selectionIndex: 1)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .play(.panic, player: "p1"),
            .choose("p2", player: "p1"),
            .choose("c23", player: "p1"),
            .stealInPlay("c23", target: "p2", player: "p1")
        ])
    }

    @Test func play_noTarget_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .build()

        // When
        // Then
        let action = GameAction.preparePlay(.panic, player: "p1")
        await #expect(throws: GameError.noChoosableTarget([.atDistance(1), .havingCard])) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
