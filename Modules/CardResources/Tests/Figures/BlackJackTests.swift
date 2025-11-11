//
//  BlackJackTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 10/11/2023.
//

import CardResources
import GameFeature
import Testing

struct BlackJackTests {
    @Test func blackJackStartTurn_withSecondDrawnCardRed_shouldDrawAnotherCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withDummyCards(["c1", "c2", "c3"])
            .withPlayer("p1") {
                $0.withAbilities([
                    .blackJack,
                    .draw2CardsOnTurnStarted
                ])
            }
            .withDeck(["c1", "c2-8♥️", "c3"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .showHand("c2-8♥️", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func blackJackStartTurn_withSecondDrawnCardBlack_shouldDoNothing() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withDummyCards(["c1", "c2"])
            .withPlayer("p1") {
                $0.withAbilities([
                    .blackJack,
                    .draw2CardsOnTurnStarted
                ])
            }
            .withDeck(["c1", "c2-A♠️"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .showHand("c2-A♠️", player: "p1")
        ])
    }
}
