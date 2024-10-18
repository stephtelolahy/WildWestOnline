//
//  IndiansTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct IndiansTests {
    @Test func playIndians_threePlayers_shouldAllowEachPlayerToCounterOrPass() async throws {
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
        let action = GameAction.preparePlay(.indians, player: "p1")
        let result = try await dispatch(action, state: state, choose: [.bang])

        // Then
        #expect(result == [
            .playBrown(.indians, player: "p1"),
            .chooseOne(.cardToDiscard, options: [.bang, .pass], player: "p2"),
            .discardHand(.bang, player: "p2"),
            .damage(1, player: "p3")
        ])
    }

    @Test func playIndians_twoPlayers_shouldAllowEachPlayerToCounter() async throws {
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
        let action = GameAction.preparePlay(.indians, player: "p1")
        let result = try await dispatch(action, state: state, choose: [.bang])

        // Then
        #expect(result == [
            .playBrown(.indians, player: "p1"),
            .chooseOne(.cardToDiscard, options: [.bang, .pass], player: "p2"),
            .discardHand(.bang, player: "p2")
        ])
    }
}
