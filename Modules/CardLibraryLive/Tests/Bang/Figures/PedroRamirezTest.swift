//
//  PedroRamirezTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 13/11/2023.
//

import GameCore
import Testing

struct PedroRamirezTest {
    @Test func startTurn_withAnotherPlayerHoldingCard_shouldAskDrawFirstCardFromPlayerThenDraw() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", figure: [.pedroRamirez])
            .withPlayer("p2", hand: ["c2"])
            .withPlayer("p3", hand: ["c3"])
            .withDeck(["c1"])
            .build()

        let result = try await dispatchUntilCompleted(.startTurn(player: "p1"), state: state)

        #expect(result == [
            .startTurn(player: "p1"),
            .choose("p2", player: "p1"),
            .choose("hiddenHand-0", player: "p1"),
            .stealHand("c2", target: "p2", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func startTurn_withAnotherPlayerHoldingCard_shouldAskDrawFirstCardFromPlayerThenPass() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", figure: [.pedroRamirez])
            .withPlayer("p2", hand: ["c2"])
            .withDeck(["c1", "c3"])
            .build()

        let choiceHandler = choiceHandlerWithResponses([
            .init(options: ["p2", .choicePass], selection: .choicePass)
        ])
        let result = try await dispatchUntilCompleted(.startTurn(player: "p1"), state: state, choiceHandler: choiceHandler)

        #expect(result == [
            .startTurn(player: "p1"),
            .choose(.choicePass, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func startTurn_withoutAnotherPlayerHoldingCard_shouldDrawCardsFromDeck() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withDummyCards(["c2"])
            .withPlayer("p1", figure: [.pedroRamirez])
            .withPlayer("p2", inPlay: ["c2"])
            .withDeck(["c1", "c3"])
            .build()

        let result = try await dispatchUntilCompleted(.startTurn(player: "p1"), state: state, ignoreError: true)

        #expect(result == [
            .startTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
