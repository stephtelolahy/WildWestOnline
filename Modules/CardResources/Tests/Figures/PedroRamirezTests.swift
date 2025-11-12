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
    @Test(.disabled()) func pedroRamirezStartTurn_withAnotherPlayerHoldingCard_shouldAskDrawFirstCardFromPlayerThenDraw() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withDummyCards(["c1", "c2"])
            .withPlayer("p1") {
                $0.withAbilities([
                    .pedroRamirez,
                    .drawCardsOnTurnStarted
                ])
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
        let choices: [Choice] = [
            .init(options: ["p2", "p3", .choicePass], selectionIndex: 0),
            .init(options: ["hiddenHand-0"], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .choose("p2", player: "p1"),
            .choose("hiddenHand-0", player: "p1"),
            .stealHand("c2", target: "p2", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func pedroRamirezStartTurn_withAnotherPlayerHoldingCard_shouldAskDrawFirstCardFromPlayerThenIgnore() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withDummyCards(["c1", "c3"])
            .withPlayer("p1") {
                $0.withAbilities([
                    .pedroRamirez,
                    .drawCardsOnTurnStarted
                ])
            }
            .withPlayer("p2") {
                $0.withHand(["c2"])
            }
            .withDeck(["c1", "c3"])
            .build()

        // When
        let action = GameFeature.Action.startTurn(player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2", .choicePass], selectionIndex: 1)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .choose(.choicePass, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func pedroRamirezStartTurn_withthoutAnotherPlayerHoldingCard_shouldDrawCardsFromDeck() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withDummyCards(["c1", "c2", "c3"])
            .withPlayer("p1") {
                $0.withAbilities([
                    .pedroRamirez,
                    .drawCardsOnTurnStarted
                ])
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
