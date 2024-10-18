//
//  PlayBrownTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 22/09/2024.
//

import Testing
import GameCore

struct PlayBrownTest {
    @Test("play brown card should remove from hand")
    func playBrown() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .build()

        // When
        let action = GameAction.playBrown("c1", player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.player("p1").hand == ["c2"])
        #expect(result.discard == ["c1"])
    }
}
