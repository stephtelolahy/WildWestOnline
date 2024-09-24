//
//  GatlingTests.swift
//
//
//  Created by Hugues Telolahy on 22/04/2023.
//

import GameCore
import Testing

struct GatlingTests {
    @Test func playGatling_withThreePlayers_shouldDamageEachPlayer() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.gatling])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameAction.preparePlay(.gatling, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .playBrown(.gatling, player: "p1"),
            .damage(1, player: "p2"),
            .damage(1, player: "p3")
        ])
    }

    @Test func playGatling_withTwoPlayers_shouldDamageEachPlayer() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.gatling])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.preparePlay(.gatling, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .playBrown(.gatling, player: "p1"),
            .damage(1, player: "p2")
        ])
    }
}
