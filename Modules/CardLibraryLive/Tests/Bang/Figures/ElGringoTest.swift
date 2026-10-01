//
//  ElGringoSpec.swift
//
//
//  Created by Hugues Telolahy on 04/11/2023.
//

import GameCore
import Testing

struct ElGringoTest {
    @Test func damaged_shouldStealHandCard() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", figure: [.elGringo], health: 3)
            .withPlayer("p2", hand: ["c2"])
            .build()

        let result = try await dispatchUntilCompleted(.damage(1, player: "p1", sourcePlayer: "p2"), state: state)

        #expect(result == [
            .damage(1, player: "p1"),
            .choose("hiddenHand-0", player: "p1"),
            .stealHand("c2", target: "p2", player: "p1")
        ])
    }

    @Test func damaged_withOffenderHavingNoCard_shouldDoNothing() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", figure: [.elGringo], health: 3)
            .withPlayer("p2")
            .build()

        let result = try await dispatchUntilCompleted(.damage(1, player: "p1", sourcePlayer: "p2"), state: state, ignoreError: true)

        #expect(result == [
            .damage(1, player: "p1")
        ])
    }

    @Test func damaged_withOffenderIsHimself_shouldDoNothing() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", figure: [.elGringo], health: 3)
            .build()

        let result = try await dispatchUntilCompleted(.damage(1, player: "p1", sourcePlayer: "p1"), state: state, ignoreError: true)

        #expect(result == [
            .damage(1, player: "p1")
        ])
    }
}
