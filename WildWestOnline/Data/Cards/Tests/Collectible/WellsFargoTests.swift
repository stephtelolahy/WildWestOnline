//
//  WellsFargoTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct WellsFargoTests {
    @Test func play_shouldDraw3Cards() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.wellsFargo])
            }
            .withPlayer("p2")
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameAction.preparePlay(.wellsFargo, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .playBrown(.wellsFargo, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
