//
//  JesseJonesTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 20/11/2023.
//

import CardResources
import GameFeature
import Testing

struct JesseJonesTests {
    @Test func jesseJonesStartTurn_withNonEmptyDiscard_shouldDrawFirstCardFromDiscard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withDummyCards(["c1", "c2"])
            .withPlayer("p1") {
                $0.withAbilities([
                    .jesseJones,
                    .drawCardsOnTurnStarted
                ])
            }
            .withDiscard(["c1"])
            .withDeck(["c2"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .drawDiscard(player: "p1"),
            .increaseCardsToDrawThisTurn(-1),
            .drawDeck(player: "p1")
        ])
    }

    @Test func jesseJonesStartTurn_withEmptyDiscard_shouldDrawCardsFromDeck() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withDummyCards(["c1", "c2"])
            .withPlayer("p1") {
                $0.withAbilities([
                    .jesseJones,
                    .drawCardsOnTurnStarted
                ])
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state, ignoreError: true)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
