//
//  PatBrennanTest.swift
//  WildWestOnline
//
//  Created by Claude on 29/09/2026.
//

import GameCore
import Testing

struct PatBrennanTest {
    @Test func startTurn_withCardInPlay_shouldDrawItInsteadOfDrawingFromDeck() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withDummyCards(["c2"])
            .withPlayer("p1") {
                $0.withFigure([.patBrennan])
            }
            .withPlayer("p2") {
                $0.withInPlay(["c2"])
                    .withHand(["c3"])
            }
            .withDeck(["c1", "c4"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .choose("p2", player: "p1"),
            .choose("c2", player: "p1"),
            .stealInPlay("c2", target: "p2", player: "p1")
        ])
    }

    @Test func startTurn_choosingPass_shouldDrawCardsFromDeck() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withDummyCards(["c2"])
            .withPlayer("p1") {
                $0.withFigure([.patBrennan])
            }
            .withPlayer("p2") {
                $0.withInPlay(["c2"])
            }
            .withDeck(["c1", "c3"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let choiceHandler = choiceHandlerWithResponses([
            .init(options: ["p2", .choicePass], selection: .choicePass)
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

    @Test func startTurn_withoutCardInPlay_shouldDrawCardsFromDeck() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.patBrennan])
            }
            .withPlayer("p2") {
                $0.withHand(["c2"])
            }
            .withDeck(["c1", "c3"])
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
