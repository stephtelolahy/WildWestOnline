//
//  EndTurnTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class EndTurnTests: XCTestCase {
    func test_endingTurn_noExcessCards_shouldDoNothing() throws {
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
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .playAbility(.endTurn, player: "p1"),
            .endTurn(player: "p1"),
            .startTurn(player: "p2")
        ])
    }

    func test_endingTurn_customHandLimit_shouldDoNothing() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
                    .withHealth(1)
                    .withAbilities([.endTurn])
                    .withAttributes([.handLimit: 10])
            }
            .withPlayer("p2")
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.preparePlay(.endTurn, player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .playAbility(.endTurn, player: "p1"),
            .endTurn(player: "p1"),
            .startTurn(player: "p2")
        ])
    }

    func test_endingTurn_oneExcessCard_shouldDiscardAHandCard() throws {
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
        let result = try awaitAction(action, state: state, choose: ["c1"])

        // Then
        XCTAssertEqual(result, [
            .playAbility(.endTurn, player: "p1"),
            .endTurn(player: "p1"),
            .chooseOne(.cardToDiscard, options: ["c1", "c2", "c3"], player: "p1"),
            .discardHand("c1", player: "p1"),
            .startTurn(player: "p2")
        ])
    }

    func test_endingTurn_twoExcessCard_shouldDiscardTwoHandCards() throws {
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
        let result = try awaitAction(action, state: state, choose: ["c1", "c3"])

        // Then
        XCTAssertEqual(result, [
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
