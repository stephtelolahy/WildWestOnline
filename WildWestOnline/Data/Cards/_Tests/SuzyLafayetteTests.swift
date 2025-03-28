//
//  SuzyLafayetteTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct SuzyLafayetteTests {
    @Test(.disabled()) func SuzyLafayette_havingNoHandCards_shouldDrawACard() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.suzyLafayette])
                    .withHand(["c1"])
            }
            .withDeck(["c2"])
            .build()

        // When
        let action = GameFeature.Action.discardHand("c1", player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .discardHand("c1", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test(.disabled()) func SuzyLafayette_havingSomeHandCards_shouldDoNothing() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.suzyLafayette])
                    .withHand(["c1", "c2"])
            }
            .build()

        // When
        let action = GameFeature.Action.discardHand("c1", player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .discardHand("c1", player: "p1")
        ])
    }
}
