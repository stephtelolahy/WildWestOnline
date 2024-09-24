//
//  PreparePlayTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 22/09/2024.
//

import Testing
@testable import GameCore

struct PreparePlayTest {
    @Test func play_withNotPlayableCard_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withCards(["c1": Card(name: "c1")])
            .build()

        // When
        // Then
        let action = GameAction.preparePlay("c1", player: "p1")
        #expect(throws: SequenceState.Error.cardNotPlayable("c1")) {
            try GameState.reducer(state, action)
        }
    }

    @Test func play_withPlayableCard_shouldApplyEffects() async throws {
        // Given
        let state = GameState.makeBuilder()
            .withPlayer("p1")
            .withCards(
                [
                    "c1": Card(
                        name: "c1",
                        effects: [
                            .init(
                                action: .drawDeck,
                                selectors: [.verify(.actorTurn)]
                            )
                        ]
                    )
                ]
            )
            .build()

        // When
        let action = GameAction.preparePlay("c1", player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(
            result.sequence.queue == [
                GameAction.prepareEffect(
                    .init(
                        action: .drawDeck,
                        card: "c1",
                        actor: "p1",
                        event: .preparePlay("c1", player: "p1"),
                        selectors: [.verify(.actorTurn)],
                        attr: [:]
                    )
                )
            ]
        )
    }
}
