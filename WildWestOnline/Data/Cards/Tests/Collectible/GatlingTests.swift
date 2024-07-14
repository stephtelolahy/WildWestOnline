//
//  GatlingTests.swift
//
//
//  Created by Hugues Telolahy on 22/04/2023.
//

import GameCore
import XCTest

final class GatlingTests: XCTestCase {
    func test_playGatling_withThreePlayers_shouldDamageEachPlayer() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.gatling])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameAction.play(.gatling, player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .play(.gatling, player: "p1"),
            .discardPlayed(.gatling, player: "p1"),
            .damage(1, player: "p2"),
            .damage(1, player: "p3")
        ])
    }

    func test_playGatling_withTwoPlayers_shouldDamageEachPlayer() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.gatling])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.play(.gatling, player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .play(.gatling, player: "p1"),
            .discardPlayed(.gatling, player: "p1"),
            .damage(1, player: "p2")
        ])
    }
}
