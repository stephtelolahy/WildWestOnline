//
//  IncreaseMagnifyingTest.swift
//
//
//  Created by Hugues Telolahy on 06/01/2024.
//

import Testing
import GameCore

struct IncreaseMagnifyingTest {
    @Test func increseMagnifying_shouldUpdatePlayerAttribute() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withMagnifying(0)
            }
            .build()
        let sut = await createGameStore(initialState: state)

        // When
        let action = GameAction.increaseMagnifying(1, player: "p1")
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.players.get("p1").magnifying == 1)
    }
}
