//
//  PanicTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
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
        let (_, error) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(error, .noPlayer(.selectAt(1)))
    }

    func test_playing_Panic_targetIsOther_havingHandCards_shouldChooseOneHandCard() {
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
        let (result, _) = awaitAction(action, state: state, choose: ["p2", "hiddenHand-0"])

        // Then
        XCTAssertEqual(result, [
            .play(.panic, player: "p1"),
            .discardPlayed(.panic, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
            .chooseOne(.card, options: ["hiddenHand-0"], player: "p1"),
            .choose("hiddenHand-0", player: "p1"),
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
        let (result, _) = awaitAction(action, state: state, choose: ["p2", "c22"])

        // Then
        XCTAssertEqual(result, [
            .play(.panic, player: "p1"),
            .discardPlayed(.panic, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
            .chooseOne(.card, options: ["c21", "c22"], player: "p1"),
            .choose("c22", player: "p1"),
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
        let (result, _) = awaitAction(action, state: state, choose: ["p2", "c23"])

        // Then
        XCTAssertEqual(result, [
            .play(.panic, player: "p1"),
            .discardPlayed(.panic, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
            .chooseOne(.card, options: ["c22", "c23", "hiddenHand-0"], player: "p1"),
            .choose("c23", player: "p1"),
            .drawInPlay("c23", target: "p2", player: "p1")
        ])
    }
}
