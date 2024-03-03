//
//  EndTurnTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class EndTurnTests: XCTestCase {
    func test_endingTurn_noExcessCards_shouldDoNothing() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAbilities([.endTurn])
            }
            .withPlayer("p2")
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.play(.endTurn, player: "p1")
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .play(.endTurn, player: "p1"),
            .setTurn(player: "p2")
        ])
    }

    func test_endingTurn_customHandLimit_shouldDoNothing() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
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
        let action = GameAction.play(.endTurn, player: "p1")
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .play(.endTurn, player: "p1"),
            .setTurn(player: "p2")
        ])
    }

    func test_endingTurn_oneExcessCard_shouldDiscardAHandCard() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2", "c3"])
                    .withHealth(2)
                    .withAbilities([.endTurn])
            }
            .withPlayer("p2")
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.play(.endTurn, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["c1"])

        // Then
        XCTAssertEqual(result, [
            .play(.endTurn, player: "p1"),
            .chooseOne(.card, options: ["c1", "c2", "c3"], player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .setTurn(player: "p2")
        ])
    }

    func test_endingTurn_twoExcessCard_shouldDiscardTwoHandCards() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2", "c3"])
                    .withHealth(1)
                    .withAbilities([.endTurn])
            }
            .withPlayer("p2")
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.play(.endTurn, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["c1", "c3"])

        // Then
        XCTAssertEqual(result, [
            .play(.endTurn, player: "p1"),
            .chooseOne(.card, options: ["c1", "c2", "c3"], player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .chooseOne(.card, options: ["c2", "c3"], player: "p1"),
            .choose("c3", player: "p1"),
            .discardHand("c3", player: "p1"),
            .setTurn(player: "p2")
        ])
    }
}
