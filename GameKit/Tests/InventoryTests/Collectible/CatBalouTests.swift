//
//  CatBalouTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Game
import XCTest

final class CatBalouTests: XCTestCase {
    func test_playingCatBalou_noPlayerAllowed_shouldThrowError() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .build()

        // When
        let action = GameAction.play(.catBalou, player: "p1")
        let (_, error) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(error, .noPlayer(.selectAny))
    }

    func test_playingCatBalou_targetIsOther_havingHandCards_shouldChooseOneRandomHandCard() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .withPlayer("p2") {
                $0.withHand(["c21"])
            }
            .build()

        // When
        let action = GameAction.play(.catBalou, player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2", .randomHand])

        // Then
        XCTAssertEqual(result, [
            .play(.catBalou, player: "p1"),
            .chooseOne([
                "p2": .nothing
            ], player: "p1"),
            .chooseOne([
                .randomHand: .discardHand("c21", player: "p2")
            ], player: "p1"),
            .discardHand("c21", player: "p2")
        ])
    }

    func test_playingCatBalou_targetIsOther_havingInPlayCards_shouldChooseOneInPlayCard() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .withPlayer("p2") {
                $0.withInPlay(["c21", "c22"])
            }
            .build()

        // When
        let action = GameAction.play(.catBalou, player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2", "c22"])

        // Then
        XCTAssertEqual(result, [
            .play(.catBalou, player: "p1"),
            .chooseOne([
                "p2": .nothing
            ], player: "p1"),
            .chooseOne([
                "c21": .discardInPlay("c21", player: "p2"),
                "c22": .discardInPlay("c22", player: "p2")
            ], player: "p1"),
            .discardInPlay("c22", player: "p2")
        ])
    }

    func test_playingCatBalou_targetIsOther_havingHandAndInPlayCards_shouldChooseAnyCard() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
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
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2", "c23"])

        // Then
        XCTAssertEqual(result, [
            .play(.catBalou, player: "p1"),
            .chooseOne([
                "p2": .nothing
            ], player: "p1"),
            .chooseOne([
                .randomHand: .discardHand("c21", player: "p2"),
                "c22": .discardInPlay("c22", player: "p2"),
                "c23": .discardInPlay("c23", player: "p2")
            ], player: "p1"),
            .discardInPlay("c23", player: "p2")
        ])
    }

    func test_playingCatBalou_targetIsSelf_shouldChooseOneInPlayCard() {
        // Given
        // When
        // Then
    }

    func test_playingCatBalou_targetIsSelf_shouldNotChooseHandCards() {
        // Given
        // When
        // Then
    }
}
