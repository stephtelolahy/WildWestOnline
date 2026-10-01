//
//  SuzyLafayetteTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct SuzyLafayetteTest {
    @Test func discardHand_havingNoHandCards_shouldDrawACard() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", figure: [.suzyLafayette], hand: ["c1"])
            .withDeck(["c2"])
            .build()

        let result = try await dispatchUntilCompleted(.discardHand("c1", player: "p1"), state: state)

        #expect(result == [
            .discardHand("c1", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func discardHand_havingSomeHandCards_shouldDoNothing() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", figure: [.suzyLafayette], hand: ["c1", "c2"])
            .build()

        let result = try await dispatchUntilCompleted(.discardHand("c1", player: "p1"), state: state)

        #expect(result == [
            .discardHand("c1", player: "p1")
        ])
    }

    @Test func play_havingNoHandCards_shouldDrawACard() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", figure: [.suzyLafayette], hand: ["c1"])
            .withDeck(["c2"])
            .withCards(["c1": Card(name: "c1", type: .collectible)])
            .build()

        let result = try await dispatchUntilCompleted(.play("c1", player: "p1"), state: state)

        #expect(result == [
            .play("c1", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func equip_havingNoHandCards_shouldDrawACard() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", figure: [.suzyLafayette], hand: ["c1"])
            .withDeck(["c2"])
            .withCards(["c1": Card(name: "c1", type: .collectible)])
            .build()

        let result = try await dispatchUntilCompleted(.equip("c1", player: "p1"), state: state)

        #expect(result == [
            .equip("c1", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func stolenHand_havingNoHandCards_shouldDrawACard() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", figure: [.suzyLafayette], hand: ["c1"])
            .withPlayer("p2")
            .withDeck(["c2"])
            .build()

        let result = try await dispatchUntilCompleted(.stealHand("c1", target: "p1", player: "p2"), state: state)

        #expect(result == [
            .stealHand("c1", target: "p1", player: "p2"),
            .drawDeck(player: "p1")
        ])
    }
}
