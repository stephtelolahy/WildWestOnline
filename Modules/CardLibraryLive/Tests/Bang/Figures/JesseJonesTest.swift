//
//  JesseJonesTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 20/11/2023.
//

import GameCore
import Testing

struct JesseJonesTest {
    @Test func startingTurn_withNonEmptyDiscard_shouldAskDrawFirstCardFromDiscardThenDraw() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", figure: [.jesseJones])
            .withDiscard(["c1"])
            .withDeck(["c2"])
            .build()

        let result = try await dispatchUntilCompleted(.startTurn(player: "p1"), state: state)

        #expect(result == [
            .startTurn(player: "p1"),
            .choose("c1", player: "p1"),
            .drawDiscard("c1", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func startingTurn_withNonEmptyDiscard_shouldAskDrawFirstCardFromDiscardThenPass() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", figure: [.jesseJones])
            .withDiscard(["c1"])
            .withDeck(["c2", "c3"])
            .build()

        let choiceHandler = choiceHandlerWithResponses([
            .init(options: ["c1", .choicePass], selection: .choicePass),
        ])
        let result = try await dispatchUntilCompleted(.startTurn(player: "p1"), state: state, choiceHandler: choiceHandler)

        #expect(result == [
            .startTurn(player: "p1"),
            .choose(.choicePass, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func startingTurn_withEmptyDiscard_shouldDrawCardsFromDeck() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", figure: [.jesseJones])
            .withDeck(["c1", "c2"])
            .build()

        let result = try await dispatchUntilCompleted(.startTurn(player: "p1"), state: state, ignoreError: true)

        #expect(result == [
            .startTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
