//
//  JesseJonesTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 20/11/2023.
//

import GameFeature
import Testing

struct JesseJonesTests {
    @Test func startingTurn_withNonEmptyDiscard_shouldAskDrawFirstCardFromDiscardThenDraw() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.jesseJones])
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
            .choose("c1", player: "p1"),
            .drawDiscard(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func startingTurn_withNonEmptyDiscard_shouldAskDrawFirstCardFromDiscardThenPass() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.jesseJones])
            }
            .withDiscard(["c1"])
            .withDeck(["c2", "c3"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let choiceHandler = choiceHandlerWithResponses([
            .init(options: ["c1", .choicePass], selection: .choicePass),
        ])
        let result = try await dispatchUntilCompleted(action, state: state, choiceHandler: choiceHandler)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .choose(.choicePass, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func startingTurn_withEmptyDiscard_shouldDrawCardsFromDeck() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.jesseJones])
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
