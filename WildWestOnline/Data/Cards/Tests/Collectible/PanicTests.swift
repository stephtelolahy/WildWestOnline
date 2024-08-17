//
//  PanicTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class PanicTests: XCTestCase {
    func test_playing_Panic_noPlayerAllowed_shouldThrowError() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .build()

        // When
        // Then
        let action = GameAction.preparePlay(.panic, player: "p1")
        XCTAssertThrowsError(try awaitAction(action, state: state)) { error in
            XCTAssertEqual(error as? ArgPlayer.Error, .noPlayer(.selectAt(1)))
        }
    }

    func test_playing_Panic_targetIsOther_havingHandCards_shouldChooseOneHandCard() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .withPlayer("p2") {
                $0.withHand(["c21"])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.panic, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2", "hiddenHand-0"])

        // Then
        XCTAssertEqual(result, [
            .preparePlay(.panic, player: "p1"),
            .playBrown(.panic, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .prepareChoose("p2", player: "p1"),
            .chooseOne(.cardToSteal, options: ["hiddenHand-0"], player: "p1"),
            .prepareChoose("hiddenHand-0", player: "p1"),
            .stealHand("c21", target: "p2", player: "p1")
        ])
    }

    func test_playing_Panic_targetIsOther_havingInPlayCards_shouldChooseInPlayCard() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .withPlayer("p2") {
                $0.withInPlay(["c21", "c22"])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.panic, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2", "c22"])

        // Then
        XCTAssertEqual(result, [
            .preparePlay(.panic, player: "p1"),
            .playBrown(.panic, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .prepareChoose("p2", player: "p1"),
            .chooseOne(.cardToSteal, options: ["c21", "c22"], player: "p1"),
            .prepareChoose("c22", player: "p1"),
            .stealInPlay("c22", target: "p2", player: "p1")
        ])
    }

    func test_playing_Panic_targetIsOther_havingHandAndInPlayCards_shouldChooseAnyCard() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
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
        let result = try awaitAction(action, state: state, choose: ["p2", "c23"])

        // Then
        XCTAssertEqual(result, [
            .preparePlay(.panic, player: "p1"),
            .playBrown(.panic, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .prepareChoose("p2", player: "p1"),
            .chooseOne(.cardToSteal, options: ["c22", "c23", "hiddenHand-0"], player: "p1"),
            .prepareChoose("c23", player: "p1"),
            .stealInPlay("c23", target: "p2", player: "p1")
        ])
    }
}
