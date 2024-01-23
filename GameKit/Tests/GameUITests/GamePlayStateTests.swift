//
//  GamePlayStateTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 23/01/2024.
//
// swiftlint:disable no_magic_numbers

import Game
@testable import GameUI
import Inventory
import XCTest

final class GamePlayStateTests: XCTestCase {
    func test_state_shouldDisplayCurrentTurnPlayer() {
        // Given
        let sut = GameState.makeBuilder()
            .withTurn("p1")
            .build()

        // When
        let result: GamePlayState = sut

        // Then
        XCTAssertEqual(result.message, "P1's turn")
    }

    func test_state_shouldDisplayStatusForEachPlayers() throws {
        // Given
        let sut = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withFigure(.willyTheKid)
                    .withHealth(1)
                    .withAttributes([.maxHealth: 3])
            }
            .withPlayer("p2") {
                $0.withFigure(.bartCassidy)
                    .withHealth(3)
                    .withAttributes([.maxHealth: 4])
            }
            .withPlayModes(["p1": .manual])
            .withTurn("p1")
            .build()

        // When
        let result: GamePlayState = sut

        // Then
        XCTAssertEqual(result.visiblePlayers.count, 2)

        let player1 = try XCTUnwrap(result.visiblePlayers[0])
        XCTAssertEqual(player1.id, "p1")
        XCTAssertEqual(player1.imageName, "willyTheKid")
        XCTAssertEqual(player1.state, .active)

        let player2 = try XCTUnwrap(result.visiblePlayers[1])
        XCTAssertEqual(player2.id, "p2")
        XCTAssertEqual(player2.imageName, "bartCassidy")
        XCTAssertEqual(player2.state, .idle)
    }

    func test_state_shouldDisplayCardActions() {
        // Given
        let sut = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withFigure(.willyTheKid)
                    .withHealth(1)
                    .withAbilities([.endTurn, .willyTheKid])
                    .withHand([.bang, .gatling])
                    .withInPlay([.saloon, .barrel])
            }
            .withPlayer("p2")
            .withPlayModes(["p1": .manual])
            .withActive([.bang, .endTurn], player: "p1")
            .build()

        // When
        let result: GamePlayState = sut

        // Then
        XCTAssertEqual(result.handActions, [
            .init(card: .bang, action: .play(.bang, player: "p1")),
            .init(card: .gatling, action: nil),
            .init(card: .endTurn, action: .play(.endTurn, player: "p1")),
            .init(card: .willyTheKid, action: nil)
        ])
    }

    func test_state_shouldDisplayChooseOneActions() {
    }
}
