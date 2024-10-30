//
//  PlayTest.swift
//  BangTests
//
//  Created by Hugues Telolahy on 28/10/2024.
//

import Testing
import Bang

struct PlayTest {

    @Test("play brown card should remove from hand")
    func playBrown() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withHand(["c1", "c2"])
            }
            .withCards(["c1": Card(name: "c1")])
            .build()

        // When
        let action = GameAction.play("c1", player: "p1")
        let result = try GameReducer().reduce(state, action)

        // Then
        #expect(result.players.get("p1").hand == ["c2"])
        #expect(result.discard == ["c1"])
    }

}
