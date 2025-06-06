//
//  DiscardExcessHandOnTurnEndedTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct DiscardExcessHandOnTurnEndedTest {
    @Test func endTurn_oneExcessCard_shouldDiscardAHandCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2", "c3"])
                    .withHealth(2)
                    .withAbilities([
                        .endTurn,
                        .discardExcessHandOnTurnEnded
                    ])
            }
            .withTurn("p1")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.endTurn, player: "p1")
        let choices: [Choice] = [
            .init(options: ["c1", "c2", "c3"], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .endTurn(player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1")
        ])
    }

    @Test func endTurn_twoExcessCard_shouldDiscardTwoHandCards() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2", "c3"])
                    .withHealth(1)
                    .withAbilities([
                        .endTurn,
                        .discardExcessHandOnTurnEnded
                    ])
            }
            .withTurn("p1")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.endTurn, player: "p1")
        let choices: [Choice] = [
            .init(options: ["c1", "c2", "c3"], selectionIndex: 0),
            .init(options: ["c2", "c3"], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .endTurn(player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .choose("c2", player: "p1"),
            .discardHand("c2", player: "p1")
        ])
    }

    @Test func endTurn_noExcessCards_shouldDoNothing() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
                    .withHealth(3)
                    .withAbilities([
                        .endTurn,
                        .discardExcessHandOnTurnEnded
                    ])
            }
            .withTurn("p1")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.endTurn, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .endTurn(player: "p1")
        ])
    }

    @Test func endTurn_customHandLimit_shouldDoNothing() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
                    .withHealth(1)
                    .withHandLimit(10)
                    .withAbilities([
                        .endTurn,
                        .discardExcessHandOnTurnEnded
                    ])
            }
            .withTurn("p1")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.endTurn, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .endTurn(player: "p1")
        ])
    }
}
