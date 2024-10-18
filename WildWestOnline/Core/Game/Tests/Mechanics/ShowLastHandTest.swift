//
//  ShowLastHandTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 22/09/2024.
//

import Testing
import GameCore

struct ShowLastHandTest {
    @Test("show last hand should do nothing")
    func showLastHand() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .build()

        // When
        let action = GameAction.showLastHand(player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result == state)
    }
}
