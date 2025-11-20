//
//  KitCarlsonTest.swift
//
//
//  Created by Hugues Telolahy on 18/11/2023.
//

import CardResources
import GameFeature
import Testing

struct KitCarlsonTests {
    @Test func kitCarlsonStartTurn_withEnoughDeckCards_shouldChooseDeckCards() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withAbilities([.kitCarlson])
            }
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .discover(),
            .discover(),
            .discover(),
            .choose("c1", player: "p1"),
            .drawDiscovered("c1", player: "p1"),
            .choose("c2", player: "p1"),
            .drawDiscovered("c2", player: "p1"),
            .undiscover()
        ])
    }
}
