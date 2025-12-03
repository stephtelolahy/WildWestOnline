//
//  PreparePlayTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 28/10/2024.
//

import Testing
@testable import GameFeature

struct PreparePlayTest {
    @Test func preparePlay_shouldQueueEffects() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c-2❤️"])
            }
            .withCards(["c": Card(name: "c", type: .collectible, effects: [.init(trigger: .cardPrePlayed, action: .play)])])
            .build()

        // When
        let action = GameFeature.Action.preparePlay("c-2❤️", player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.queue.count == 1)
    }

    @Test func preparePlay_shouldResetPlayable() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c-2❤️"])
            }
            .withCards(["c": Card(name: "c", type: .collectible, effects: [.init(trigger: .cardPrePlayed, action: .play)])])
            .withPlayable(["c-2❤️"], player: "p1")
            .build()

        // When
        let action = GameFeature.Action.preparePlay("c-2❤️", player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.playable == nil)
    }

    @Test func preparePlay_withoutEffects_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .withCards(["c1": Card(name: "c1", type: .collectible)])
            .build()

        // When
        // Assert
        let action = GameFeature.Action.preparePlay("c1", player: "p1")
        await #expect(throws: GameFeature.Error.cardNotPlayable("c1")) {
            try await dispatch(action, state: state)
        }
    }
}
