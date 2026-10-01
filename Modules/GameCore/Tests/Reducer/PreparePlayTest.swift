//
//  PreparePlayTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 28/10/2024.
//

import Testing
@testable import GameCore

struct PreparePlayTest {
    @Test func preparePlay_shouldQueueEffects() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1", hand: ["c-2❤️"])
            .withCards(["c": Card(name: "c", type: .collectible, effects: [.init(trigger: .prePlayed, action: .play)])])
            .build()

        let action = GameFeature.Action.preparePlay("c-2❤️", player: "p1")
        let result = try await dispatch(action, state: state)

        #expect(result.queue.count == 1)
    }

    @Test func preparePlay_shouldResetPlayable() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1", hand: ["c-2❤️"])
            .withCards(["c": Card(name: "c", type: .collectible, effects: [.init(trigger: .prePlayed, action: .play)])])
            .withPlayable(["c-2❤️"], player: "p1")
            .build()

        let action = GameFeature.Action.preparePlay("c-2❤️", player: "p1")
        let result = try await dispatch(action, state: state)

        #expect(result.playable == nil)
    }

    @Test func preparePlay_withoutEffects_shouldThrowError() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1", hand: ["c1", "c2"])
            .withCards(["c1": Card(name: "c1", type: .collectible)])
            .build()

        // Assert
        await #expect(throws: GameFeature.Error.cardNotPlayable("c1")) {
            try await dispatch(.preparePlay("c1", player: "p1"), state: state)
        }
    }
}
