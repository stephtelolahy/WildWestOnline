//
//  PedroRamirezTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 13/11/2023.
//

import CardsData
import GameCore
import XCTest

final class PedroRamirezTests: XCTestCase {
    func test_pedroRamirez_shouldHaveSpecialStartTurn() throws {
        // Given
        let state = Setup.buildGame(figures: [.pedroRamirez], deck: [], cards: Cards.all)

        // When
        let player = state.player(.pedroRamirez)

        // Then
        XCTAssertFalse(player.abilities.contains(.drawOnStartTurn))
    }

    func test_pedroRamirezStartTurn_withAnotherPlayerHoldingCard_shouldAskDrawFirstCardFromPlayerThenDraw() throws {
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
        let result = try awaitAction(action, state: state, choose: ["p2", "hiddenHand-0"])

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .chooseOne(.target, options: ["p2", "p3", .pass], player: "p1"),
            .chooseOne(.cardToSteal, options: ["hiddenHand-0"], player: "p1"),
            .stealHand("c2", target: "p2", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_pedroRamirezStartTurn_withAnotherPlayerHoldingCard_shouldAskDrawFirstCardFromPlayerThenIgnore() throws {
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
        let result = try awaitAction(action, state: state, choose: [.pass])

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .chooseOne(.target, options: ["p2", "p3", .pass], player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_pedroRamirezStartTurn_withthoutAnotherPlayerHoldingCard_shouldDrawCardsFromDeck() throws {
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
        let result = try awaitAction(action, state: state)

        // Then
        #expect(result == [
            .startTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
