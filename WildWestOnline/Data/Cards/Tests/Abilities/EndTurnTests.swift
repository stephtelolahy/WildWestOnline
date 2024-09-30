//
//  EndTurnTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct EndTurnTests {
    @Test func endingTurn_noExcessCards_shouldDoNothing() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.endTurn])
            }
            .withPlayer("p2")
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.preparePlay(.endTurn, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .playAbility(.endTurn, player: "p1"),
            .endTurn(player: "p1"),
            .startTurn(player: "p2")
        ])
    }

    @Test func endingTurn_customHandLimit_shouldDoNothing() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
                    .withHealth(1)
                    .withAbilities([.endTurn])
                    .withHandLimit(10)
            }
            .withPlayer("p2")
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.preparePlay(.endTurn, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .playAbility(.endTurn, player: "p1"),
            .endTurn(player: "p1"),
            .startTurn(player: "p2")
        ])
    }

    @Test func endingTurn_oneExcessCard_shouldDiscardAHandCard() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2", "c3"])
                    .withHealth(2)
                    .withAbilities([.endTurn, .discardExcessHandOnEndTurn])
            }
            .withPlayer("p2")
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.preparePlay(.endTurn, player: "p1")
        let result = try await dispatch(action, state: state, choose: ["c1"])

        // Then
        #expect(result == [
            .playAbility(.endTurn, player: "p1"),
            .endTurn(player: "p1"),
            .chooseOne(.cardToDiscard, options: ["c1", "c2", "c3"], player: "p1"),
            .discardHand("c1", player: "p1"),
            .startTurn(player: "p2")
        ])
    }

    @Test func endingTurn_twoExcessCard_shouldDiscardTwoHandCards() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2", "c3"])
                    .withHealth(1)
                    .withAbilities([.endTurn, .discardExcessHandOnEndTurn])
            }
            .withPlayer("p2")
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.preparePlay(.endTurn, player: "p1")
        let result = try await dispatch(action, state: state, choose: ["c1", "c3"])

        // Then
        #expect(result == [
            .playAbility(.endTurn, player: "p1"),
            .endTurn(player: "p1"),
            .chooseOne(.cardToDiscard, options: ["c1", "c2", "c3"], player: "p1"),
            .discardHand("c1", player: "p1"),
            .chooseOne(.cardToDiscard, options: ["c2", "c3"], player: "p1"),
            .discardHand("c3", player: "p1"),
            .startTurn(player: "p2")
        ])
    }
}
