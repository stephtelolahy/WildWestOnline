//
//  PanicTest.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 04/11/2024.
//

import Testing
import GameFeature

struct PanicTest {
    @Test func play_targetHavingHandCards_shouldChooseOneHandCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .withPlayer("p2") {
                $0.withHand(["c21"])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.panic, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2", .choicePass], selectionIndex: 0),
            .init(options: ["hiddenHand-0"], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices, ignoreError: true)

        // Then
        #expect(result == [
            .choose("p2", player: "p1"),
            .choose("hiddenHand-0", player: "p1"),
            .play(.panic, player: "p1", target: "p2", card: "c21"),
            .stealHand("c21", target: "p2", player: "p1")
        ])
    }

    @Test func play_targetHavingInPlayCards_shouldChooseInPlayCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withDummyCards(["c21", "c22"])
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .withPlayer("p2") {
                $0.withInPlay(["c21", "c22"])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.panic, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2", .choicePass], selectionIndex: 0),
            .init(options: ["c21", "c22"], selectionIndex: 1)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices, ignoreError: true)

        // Then
        #expect(result == [
            .choose("p2", player: "p1"),
            .choose("c22", player: "p1"),
            .play(.panic, player: "p1", target: "p2", card: "c22"),
            .stealInPlay("c22", target: "p2", player: "p1")
        ])
    }

    @Test func play_targetHavingHandAndInPlayCards_shouldChooseAnyCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
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
        let action = GameFeature.Action.preparePlay(.panic, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2", .choicePass], selectionIndex: 0),
            .init(options: ["c22", "c23", "hiddenHand-0"], selectionIndex: 1)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices, ignoreError: true)

        // Then
        #expect(result == [
            .choose("p2", player: "p1"),
            .choose("c23", player: "p1"),
            .play(.panic, player: "p1", target: "p2", card: "c23"),
            .stealInPlay("c23", target: "p2", player: "p1")
        ])
    }

    @Test func play_noTarget_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .build()

        // When
        // Then
        let action = GameFeature.Action.preparePlay(.panic, player: "p1")
        await #expect(throws: GameFeature.Error.noChoosableTarget([.atDistance(1), .hasCards])) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
