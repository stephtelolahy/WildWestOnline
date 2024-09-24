//
//  PedroRamirezTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 13/11/2023.
//

import CardsData
import GameCore
import Testing

struct PedroRamirezTests {
    /*
    @Test func pedroRamirezStartTurn_withAnotherPlayerHoldingCard_shouldAskDrawFirstCardFromPlayerThenDraw() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.pedroRamirez])
                    .withAttributes([.startTurnCards: 2])
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
        let action = GameAction.startTurn(player: "p1")
        let result = try await dispatch(action, state: state, choose: ["p2", "hiddenHand-0"])

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .chooseOne(.target, options: ["p2", "p3", .pass], player: "p1"),
            .chooseOne(.cardToSteal, options: ["hiddenHand-0"], player: "p1"),
            .stealHand("c2", target: "p2", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func pedroRamirezStartTurn_withAnotherPlayerHoldingCard_shouldAskDrawFirstCardFromPlayerThenIgnore() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.pedroRamirez])
                    .withAttributes([.startTurnCards: 2])
            }
            .withPlayer("p2") {
                $0.withHand(["c2"])
            }
            .withPlayer("p3") {
                $0.withHand(["c3"])
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.startTurn(player: "p1")
        let result = try await dispatch(action, state: state, choose: [.pass])

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .chooseOne(.target, options: ["p2", "p3", .pass], player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func pedroRamirezStartTurn_withthoutAnotherPlayerHoldingCard_shouldDrawCardsFromDeck() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.pedroRamirez])
                    .withAttributes([.startTurnCards: 2])
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.startTurn(player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
     */
}
