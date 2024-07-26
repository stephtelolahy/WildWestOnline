//
//  IndiansTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class IndiansTests: XCTestCase {
    func test_playIndians_threePlayers_shouldAllowEachPlayerToCounterOrPass() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.indians])
            }
            .withPlayer("p2") {
                $0.withHand([.bang])
            }
            .withPlayer("p3")
            .build()

        // When
        let action = GameAction.play(.indians, player: "p1")
        let result = try awaitAction(action, state: state, choose: [.bang])

        // Then
        XCTAssertEqual(result, [
            .play(.indians, player: "p1"),
            .discardPlayed(.indians, player: "p1"),
            .chooseOne(.cardToDiscard, options: [.bang, .pass], player: "p2"),
            .choose(.bang, player: "p2"),
            .discardHand(.bang, player: "p2"),
            .damage(1, player: "p3")
        ])
    }

    func test_playIndians_twoPlayers_shouldAllowEachPlayerToCounter() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.indians])
            }
            .withPlayer("p2") {
                $0.withHand([.bang])
            }
            .build()

        // When
        let action = GameAction.play(.indians, player: "p1")
        let result = try awaitAction(action, state: state, choose: [.bang])

        // Then
        XCTAssertEqual(result, [
            .play(.indians, player: "p1"),
            .discardPlayed(.indians, player: "p1"),
            .chooseOne(.cardToDiscard, options: [.bang, .pass], player: "p2"),
            .choose(.bang, player: "p2"),
            .discardHand(.bang, player: "p2")
        ])
    }
}
