//
//  KitCarlsonTest.swift
//
//
//  Created by Hugues Telolahy on 18/11/2023.
//

import GameData
import GameFeature
import Testing

struct KitCarlsonTests {
    @Test(.disabled()) func kitCarlsonStartTurn_withEnoughDeckCards_shouldChooseDeckCards() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.kitCarlson])
                    .withAttributes([.startTurnCards: 2])
                    .withHand(["c0"])
            }
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try awaitAction(action, state: state, choose: ["c2"])

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .chooseOne(.cardToPutBack, options: ["c1", "c2", "c3"], player: "p1"),
            .putBack("c2", player: "p1")
        ])
    }

    @Test(.disabled()) func kitCarlsonStartTurn_withoutEnoughDeckCards_shouldChooseDeckCards() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.kitCarlson])
                    .withAttributes([.startTurnCards: 2])
            }
            .withDeck(["c1", "c2"])
            .withDiscard(["c3", "c3"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try awaitAction(action, state: state, choose: ["c2"])

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .chooseOne(.cardToPutBack, options: ["c1", "c2", "c3"], player: "p1"),
            .putBack("c2", player: "p1")
        ])
    }
}
