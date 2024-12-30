//
//  GatlingTest.swift
//
//
//  Created by Hugues Telolahy on 22/04/2023.
//

import Testing
import GameCore

struct GatlingTest {
    @Test func play_withThreePlayers_shouldDamageEachPlayer() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.gatling])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameAction.play(.gatling, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .play(.gatling, player: "p1"),
            .discardPlayed(.gatling, player: "p1"),
            .shoot("p2", player: "p1"),
            .damage(1, player: "p2"),
            .shoot("p3", player: "p1"),
            .damage(1, player: "p3")
        ])
    }

    @Test func play_withTwoPlayers_shouldDamageEachPlayer() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.gatling])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.play(.gatling, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .play(.gatling, player: "p1"),
            .discardPlayed(.gatling, player: "p1"),
            .shoot("p2", player: "p1"),
            .damage(1, player: "p2")
        ])
    }
}
