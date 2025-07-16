//
//  PreparePlayTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 28/10/2024.
//

import Testing
import GameCore
import Combine

struct PreparePlayTest {
    @Test func play_shouldNotDiscard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1"])
            }
            .withCards(["c1": Card(name: "c1", type: .brown, onPreparePlay: [.init(name: .drawDeck)])])
            .build()

        // When
        let action = GameFeature.Action.preparePlay("c1", player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.players.get("p1").hand == ["c1"])
        #expect(result.discard.isEmpty)
    }

    @Test func play_firstTime_shouldSetPlayedThisTurn() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1"])
            }
            .withCards(["c1": Card(name: "c1", type: .brown, onPreparePlay: [.init(name: .drawDeck)])])
            .build()

        // When
        let action = GameFeature.Action.preparePlay("c1", player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.playedThisTurn["c1"] == 1)
    }

    @Test func play_secondTime_shouldIncrementPlayedThisTurn() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1"])
            }
            .withCards(["c1": Card(name: "c1", type: .brown, onPreparePlay: [.init(name: .drawDeck)])])
            .withPlayedThisTurn(["c1": 1])
            .build()

        // When
        let action = GameFeature.Action.preparePlay("c1", player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.playedThisTurn["c1"] == 2)
    }

    @Test func play_shouldQueueEffectsOfMatchingCardName() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c-2❤️"])
            }
            .withCards(["c": Card(name: "c", type: .brown, onPreparePlay: [.init(name: .drawDeck)])])
            .build()

        // When
        let action = GameFeature.Action.preparePlay("c-2❤️", player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.queue.count == 1)
    }

    @Test func play_withoutEffects_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .withCards(["c1": Card(name: "c1", type: .brown)])
            .build()

        // When
        // Assert
        let action = GameFeature.Action.preparePlay("c1", player: "p1")
        await #expect(throws: Card.PlayError.cardNotPlayable("c1")) {
            try await dispatch(action, state: state)
        }
    }
}
