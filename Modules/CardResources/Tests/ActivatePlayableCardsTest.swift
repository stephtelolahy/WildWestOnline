//
//  ActivatePlayableCardsTest.swift
//
//
//  Created by Hugues Telolahy on 05/06/2023.
//

import Testing
import GameFeature

struct ActivatePlayableCardsTest {
    @Test func idle_withPlayableCards_shouldActivate() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withHand([.saloon, .gatling, .beer, .missed])
                    .withMaxHealth(4)
                    .withHealth(2)
            }
            .withPlayer("p2")
            .withTurn("p1")
            .withDeck(["c1"])
            .withShowPlayableCards(true)
            .build()

        // When
        let action = GameFeature.Action.dummy
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .activate([.saloon, .gatling, .endTurn], player: "p1")
        ])
    }

    @Test func idle_withoutPlayableCards_shouldDoNothing() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.beer, .missed])
                    .withMaxHealth(4)
                    .withHealth(4)
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .withTurn("p1")
            .withShowPlayableCards(true)
            .build()

        // When
        let action = GameFeature.Action.dummy
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result.isEmpty)
    }
}
