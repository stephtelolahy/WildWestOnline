//
//  PedroRamirezTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 13/11/2023.
//
// swiftlint:disable no_magic_numbers

import Game
import Inventory
import XCTest

final class PedroRamirezTests: XCTestCase {
    func test_pedroRamirez_shouldHaveSpecialStartTurn() throws {
        // Given
        let state = Setup.buildGame(figures: [.pedroRamirez], deck: [], cardRef: CardList.all)

        // When
        let player = state.player(.pedroRamirez)

        // Then
        XCTAssertFalse(player.abilities.contains(.drawOnSetTurn))
    }

    func test_pedroRamirezStartTurn_withAnotherPlayerHoldingCard_shouldAskDrawFirstCardFromPlayer() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
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
        let action = GameAction.setTurn(player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .setTurn(player: "p1"),
            .chooseOne([
                "p2": .drawHand("c2", target: "p2", player: "p1"),
                "p3": .drawHand("c3", target: "p3", player: "p1")
            ], player: "p1"),
            .drawHand("c2", target: "p2", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_pedroRamirezStartTurn_withthoutAnotherPlayerHoldingCard_shouldDrawCardsFromDeck() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAbilities([.pedroRamirez])
                    .withAttributes([.startTurnCards: 2])
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.setTurn(player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .setTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
