//
//  IndiansTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct IndiansTest {
    @Test func play_shouldAllowEachPlayerToCounterOrPass() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.indians])
            .withPlayer("p2", hand: [.bang])
            .withPlayer("p3")
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.indians, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.indians, player: "p1"),
            .play(.indians, player: "p1"),
            .choose(.bang, player: "p2"),
            .discardHand(.bang, player: "p2"),
            .damage(1, player: "p3")
        ])
    }
}
