//
//  PlayTest.swift
//  BangTests
//
//  Created by Hugues Telolahy on 28/10/2024.
//

import Testing
import GameCore

struct PlayTest {
    @Test func play_shouldNotDiscard() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1"])
            }
            .withCards(["c1": Card(name: "c1", onPlay: [.init(action: .drawDeck)])])
            .build()

        // When
        let action = GameAction.play("c1", player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.players.get("p1").hand == ["c1"])
        #expect(result.discard.isEmpty)
    }

    @Test func play_firstTime_shouldSetPlayedThisTurn() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1"])
            }
            .withCards(["c1": Card(name: "c1", onPlay: [.init(action: .drawDeck)])])
            .build()

        // When
        let action = GameAction.play("c1", player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.playedThisTurn["c1"] == 1)
    }

    @Test func play_secondTime_shouldIncrementPlayedThisTurn() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1"])
            }
            .withCards(["c1": Card(name: "c1", onPlay: [.init(action: .drawDeck)])])
            .withPlayedThisTurn(["c1": 1])
            .build()

        // When
        let action = GameAction.play("c1", player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.playedThisTurn["c1"] == 2)
    }

    @Test func play_shouldQueueEffectsOfMatchingCardName() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c-2❤️"])
            }
            .withCards(["c": Card(name: "c", onPlay: [.init(action: .drawDeck)])])
            .build()

        // When
        let action = GameAction.play("c-2❤️", player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.queue.count == 1)
    }

    @Test func play_withoutEffects_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .withCards(["c1": Card(name: "c1")])
            .build()

        // When
        // Assert
        let action = GameAction.play("c1", player: "p1")
        #expect(throws: GameError.cardNotPlayable("c1")) {
            try GameReducer().reduce(state, action)
        }
    }
}
