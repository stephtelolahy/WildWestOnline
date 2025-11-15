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
            .withAllCards()
            .withPlayer("p1") {
                $0.withAbilities([
                    .kitCarlson,
                    .draw2CardsOnTurnStarted
                ])
            }
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let choices: [Choice] = [
            .init(options: ["c1", "c2", "c3"], selectionIndex: 0),
            .init(options: ["c2", "c3"], selectionIndex: 0),
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

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
