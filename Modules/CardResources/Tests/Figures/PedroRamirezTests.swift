//
//  PedroRamirezTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 13/11/2023.
//

import CardResources
import GameFeature
import Testing

struct PedroRamirezTests {
    @Test func startTurn_withAnotherPlayerHoldingCard_shouldAskDrawFirstCardFromPlayerThenDraw() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.pedroRamirez])
            }
            .withPlayer("p2") {
                $0.withHand(["c2"])
            }
            .withPlayer("p3") {
                $0.withHand(["c3"])
            }
            .withDeck(["c1"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .choose("p2", player: "p1"),
            .choose("hiddenHand-0", player: "p1"),
            .stealHand("c2", target: "p2", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func startTurn_withAnotherPlayerHoldingCard_shouldAskDrawFirstCardFromPlayerThenPass() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.pedroRamirez])
            }
            .withPlayer("p2") {
                $0.withHand(["c2"])
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

    @Test func startTurn_withoutAnotherPlayerHoldingCard_shouldDrawCardsFromDeck() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withDummyCards(["c2"])
            .withPlayer("p1") {
                $0.withFigure([.pedroRamirez])
            }
            .withPlayer("p2") {
                $0.withInPlay(["c2"])
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
