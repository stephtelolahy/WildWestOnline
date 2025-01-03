//
//  PassInPlayTest.swift
//  
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import Testing
import GameCore

struct PassInPlayTest {
    @Test func passInPlay_shouldRemoveCardFromInPlay() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withInPlay(["c1", "c2"])
            }
            .withPlayer("p2")
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.passInPlay("c1", target: "p2", player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.players.get("p1").inPlay == ["c2"])
        await #expect(sut.state.players.get("p2").inPlay == ["c1"])
    }
}
