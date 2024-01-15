//
//  IndiansTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Game
import XCTest

final class IndiansTests: XCTestCase {
    func test_playIndians_threePlayers_shouldAllowEachPlayerToCounterOrPass() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
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
        let (result, _) = self.awaitAction(action, state: state, choose: [.bang])

        // Then
        XCTAssertEqual(result, [
            .play(.indians, player: "p1"),
            .discardPlayed(.indians, player: "p1"),
            .chooseOne(.card, options: [.bang, .pass], player: "p2"),
            .choose(.bang, player: "p2"),
            .discardHand(.bang, player: "p2"),
            .damage(1, player: "p3")
        ])
    }

    func test_playIndians_twoPlayers_shouldAllowEachPlayerToCounter() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.indians])
            }
            .withPlayer("p2") {
                $0.withHand([.bang])
            }
            .build()

        // When
        let action = GameAction.play(.indians, player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: [.bang])

        // Then
        XCTAssertEqual(result, [
            .play(.indians, player: "p1"),
            .discardPlayed(.indians, player: "p1"),
            .chooseOne(.card, options: [.bang, .pass], player: "p2"),
            .choose(.bang, player: "p2"),
            .discardHand(.bang, player: "p2")
        ])
    }
}
