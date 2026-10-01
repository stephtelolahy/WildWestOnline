//
//  BartCassidyTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct BartCassidyTest {
    @Test func beingDamaged_1LifePoint_shouldDrawACard() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", figure: [.bartCassidy], health: 3)
            .withDeck(["c1"])
            .build()

        let result = try await dispatchUntilCompleted(.damage(1, player: "p1"), state: state)

        #expect(result == [
            .damage(1, player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func beingDamaged_2LifePoints_shouldDraw2Cards() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", figure: [.bartCassidy], health: 3)
            .withDeck(["c1", "c2"])
            .build()

        let result = try await dispatchUntilCompleted(.damage(2, player: "p1"), state: state)

        #expect(result == [
            .damage(2, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func beingDamaged_Lethal_shouldDoNothing() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", figure: [.bartCassidy], health: 1)
            .withDeck(["c1"])
            .build()

        let result = try await dispatchUntilCompleted(.damage(1, player: "p1"), state: state)

        #expect(result == [
            .damage(1, player: "p1")
        ])
    }
}
