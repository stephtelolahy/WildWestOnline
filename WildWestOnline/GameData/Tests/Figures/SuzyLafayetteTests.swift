//
//  SuzyLafayetteTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct SuzyLafayetteTests {
    @Test func suzyLafayette_discardHand_havingNoHandCards_shouldDrawACard() async throws {
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

    @Test func suzyLafayette_discardHand_havingSomeHandCards_shouldDoNothing() async throws {
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

    @Test func suzyLafayette_play_havingNoHandCards_shouldDrawACard() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.suzyLafayette])
                    .withHand(["c1"])
            }
            .withDeck(["c2"])
            .withCards(["c1": Card(name: "c1", type: .brown)])
            .build()

        // When
        let action = GameFeature.Action.play("c1", player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .play("c1", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func suzyLafayette_equip_havingNoHandCards_shouldDrawACard() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.suzyLafayette])
                    .withHand(["c1"])
            }
            .withDeck(["c2"])
            .withCards(["c1": Card(name: "c1", type: .brown)])
            .build()

        // When
        let action = GameFeature.Action.equip("c1", player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .equip("c1", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func suzyLafayette_stolenHand_havingNoHandCards_shouldDrawACard() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.suzyLafayette])
                    .withHand(["c1"])
            }
            .withPlayer("p2")
            .withDeck(["c2"])
            .build()

        // When
        let action = GameFeature.Action.stealHand("c1", target: "p1", player: "p2")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .stealHand("c1", target: "p1", player: "p2"),
            .drawDeck(player: "p1")
        ])
    }
}
