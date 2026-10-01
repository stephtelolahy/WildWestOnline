//
//  TequilaJoeTest.swift
//  WildWestOnline
//
//  Created by Claude on 29/09/2026.
//

import GameCore
import Testing

struct TequilaJoeTest {
    @Test func playingBeer_shouldHealTwoLifePoints() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.tequilaJoe])
                    .withHand([.beer])
                    .withHealth(1)
                    .withMaxHealth(4)
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.beer, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.beer, player: "p1"),
            .play(.beer, player: "p1"),
            .heal(2, player: "p1")
        ])
    }

    @Test func playingOtherHealCard_shouldHealNormally() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.tequilaJoe])
                    .withHand([.saloon])
                    .withHealth(1)
                    .withMaxHealth(4)
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.saloon, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.saloon, player: "p1"),
            .play(.saloon, player: "p1"),
            .heal(1, player: "p1")
        ])
    }
}
