//
//  ElGringoSpec.swift
//
//
//  Created by Hugues Telolahy on 04/11/2023.
//
import Game
import XCTest

final class ElGringoTests: XCTestCase {

    func test_elGringoDamaged_withOffenderHavingHandCards_ShouldStealRandomCard() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAttributes([.elGringo: 0])
                    .withHealth(3)
            }
            .withPlayer("p2") {
                $0.withHand([.bang, "c2", "c2"])
            }
            .withTurn("p2")
            .build()

        // When
        let action = GameAction.playImmediate(.bang, target: "p1", player: "p2")
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .playImmediate(.bang, target: "p1", player: "p2"),
            .damage(1, player: "p1"),
            .stealHand("c2", target: "p2", player: "p1")
        ])
    }

    func test_elGringoDamaged_withOffenderHavingNoCard_ShouldDoNothing() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAttributes([.elGringo: 0])
                    .withHealth(3)
            }
            .withPlayer("p2") {
                $0.withHand([.bang])
            }
            .withTurn("p2")
            .build()

        // When
        let action = GameAction.playImmediate(.bang, target: "p1", player: "p2")
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .playImmediate(.bang, target: "p1", player: "p2"),
            .damage(1, player: "p1")
        ])
    }

    func test_elGringoDamaged_withOffenderIsHimself_ShouldDoNothing() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAttributes([.elGringo: 0])
                    .withHealth(3)
            }
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.damage(1, player: "p1")
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .damage(1, player: "p1")
        ])
    }
}
