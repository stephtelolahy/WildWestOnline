//
//  IndiansTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameFeature

struct IndiansTest {
    @Test func play_shouldAllowEachPlayerToCounterOrPass() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.indians])
            }
            .withPlayer("p2") {
                $0.withHand([.bang])
            }
            .withPlayer("p3")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.indians, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.indians, player: "p1"),
            .play(.indians, player: "p1"),
            .choose(.bang, player: "p2"),
            .discardHand(.bang, player: "p2"),
            .damage(1, player: "p3")
        ])
    }
}
