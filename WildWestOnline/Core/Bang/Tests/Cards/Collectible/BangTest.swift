//
//  BangTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import Bang

struct BangTest {
    @Test func play_shouldDeal1Damage() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2", "p3"], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .play(.bang, player: "p1"),
            .choose("p2", player: "p1"),
            .shoot("p2", player: "p1"),
            .damage(1, player: "p2")
        ])
    }

    @Test func play_reachedLimitPerTurn_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2")
            .withPlayedThisTurn([.bang: 1])
            .build()

        // When
        // Assert
        let action = GameAction.play(.bang, player: "p1")
        await #expect(throws: GameError.noReq(.playedThisTurnAtMost([.bang: 1]))) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }

    @Test func play_noPlayerReachable_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2") {
                $0.withRemoteness(1)
            }
            .build()

        // When
        // Then
        let action = GameAction.play(.bang, player: "p1")
        await #expect(throws: GameError.noChoosableTarget([.reachable])) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
