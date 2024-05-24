//
//  CatBalouTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class CatBalouTests: XCTestCase {
    func test_playingCatBalou_noPlayerAllowed_shouldThrowError() {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .build()

        // When
        let action = GameAction.play(.catBalou, player: "p1")
        let (_, error) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(error, .noPlayer(.selectAny))
    }

    func test_playingCatBalou_targetIsOther_havingHandCards_shouldChooseOneHandCard() {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .withPlayer("p2") {
                $0.withHand(["c21"])
            }
            .build()

        // When
        let action = GameAction.play(.catBalou, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["p2", "hiddenHand-0"])

        // Then
        XCTAssertEqual(result, [
            .play(.catBalou, player: "p1"),
            .discardPlayed(.catBalou, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
            .chooseOne(.cardToDiscard, options: ["hiddenHand-0"], player: "p1"),
            .choose("hiddenHand-0", player: "p1"),
            .discardHand("c21", player: "p2")
        ])
    }

    func test_playingCatBalou_targetIsOther_havingInPlayCards_shouldChooseOneInPlayCard() {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .withPlayer("p2") {
                $0.withInPlay(["c21", "c22"])
            }
            .build()

        // When
        let action = GameAction.play(.catBalou, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["p2", "c22"])

        // Then
        XCTAssertEqual(result, [
            .play(.catBalou, player: "p1"),
            .discardPlayed(.catBalou, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
            .chooseOne(.cardToDiscard, options: ["c21", "c22"], player: "p1"),
            .choose("c22", player: "p1"),
            .discardInPlay("c22", player: "p2")
        ])
    }

    func test_playingCatBalou_targetIsOther_havingHandAndInPlayCards_shouldChooseAnyCard() {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .withPlayer("p2") {
                $0.withHand(["c21"])
                    .withInPlay(["c22", "c23"])
            }
            .build()

        // When
        let action = GameAction.play(.catBalou, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["p2", "c23"])

        // Then
        XCTAssertEqual(result, [
            .play(.catBalou, player: "p1"),
            .discardPlayed(.catBalou, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
            .chooseOne(.cardToDiscard, options: ["c22", "c23", "hiddenHand-0"], player: "p1"),
            .choose("c23", player: "p1"),
            .discardInPlay("c23", player: "p2")
        ])
    }
}
