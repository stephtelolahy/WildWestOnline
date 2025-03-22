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
        // Given
        let state = GameState.makeBuilderWithAllCards()
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
        let choices: [Choice] = [
            .init(options: [.bang, .pass], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .play(.indians, player: "p1"),
            .choose(.bang, player: "p2"),
            .discardHand(.bang, player: "p2"),
            .damage(1, player: "p3")
        ])
    }
}
