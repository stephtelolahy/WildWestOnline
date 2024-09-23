//
//  PlayAbilityTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 22/09/2024.
//

import Testing
import GameCore

struct PlayAbilityTest {
    @Test("play ability should do nothing")
    func playBrown() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withAbilities(["c1", "c2"])
            }
            .build()

        // When
        let action = GameAction.playAbility("c1", player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result == state)
    }
}
