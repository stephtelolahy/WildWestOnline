//
//  WellsFargoTest.swift
//
//  Created by Hugues Telolahy on 30/10/2024.
//

import Testing
import GameFeature

struct WellsFargoTest {
    @Test func play_shouldDraw3Cards() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.wellsFargo])
            }
            .withPlayer("p2")
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.wellsFargo, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .play(.wellsFargo, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
