//
//  PanicTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Game
import XCTest

final class PanicTests: XCTestCase {
    func test_playing_Panic_noPlayerAllowed_shouldThrowError() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .build()

        // When
        let action = GameAction.play(.panic, player: "p1")
        let (_, error) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(error, .noPlayer(.selectAt(1)))
    }

    func test_playing_Panic_targetIsOther_havingHandCards_shouldChooseOneRandomHandCard() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .withPlayer("p2") {
                $0.withHand(["c21"])
            }
            .build()

        // When
        let action = GameAction.play(.panic, player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2", .randomHand])

        // Then
        XCTAssertEqual(result, [
            .play(.panic, player: "p1"),
            .discardPlayed(.panic, player: "p1"),
            .chooseOne([
                "p2": .play(.panic, player: "p1")
            ], player: "p1"),
            .chooseOne([
                .randomHand: .drawHand("c21", target: "p2", player: "p1")
            ], player: "p1"),
            .drawHand("c21", target: "p2", player: "p1")
        ])
    }

    func test_playing_Panic_targetIsOther_havingInPlayCards_shouldChooseInPlayCard() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .withPlayer("p2") {
                $0.withInPlay(["c21", "c22"])
            }
            .build()

        // When
        let action = GameAction.play(.panic, player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2", "c22"])

        // Then
        XCTAssertEqual(result, [
            .play(.panic, player: "p1"),
            .discardPlayed(.panic, player: "p1"),
            .chooseOne([
                "p2": .nothing
            ], player: "p1"),
            .chooseOne([
                "c21": .drawInPlay("c21", target: "p2", player: "p1"),
                "c22": .drawInPlay("c22", target: "p2", player: "p1")
            ], player: "p1"),
            .drawInPlay("c22", target: "p2", player: "p1")
        ])
    }

    func test_playing_Panic_targetIsOther_havingHandAndInPlayCards_shouldChooseAnyCard() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
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
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2", "c23"])

        // Then
        XCTAssertEqual(result, [
            .play(.panic, player: "p1"),
            .discardPlayed(.panic, player: "p1"),
            .chooseOne([
                "p2": .nothing
            ], player: "p1"),
            .chooseOne([
                .randomHand: .drawHand("c21", target: "p2", player: "p1"),
                "c22": .drawInPlay("c22", target: "p2", player: "p1"),
                "c23": .drawInPlay("c23", target: "p2", player: "p1")
            ], player: "p1"),
            .drawInPlay("c23", target: "p2", player: "p1")
        ])
    }

    func test_playing_Panic_targetIsSelf_shouldChooseInPlayCard() {
        // Given
        // When
        // Then
    }

    func test_playing_Panic_targetIsSelf_shouldNotChooseHandCard() {
        // Given
        // When
        // Then
    }
}
