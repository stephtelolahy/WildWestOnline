//
//  PedroRamirezTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 13/11/2023.
//

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
        XCTAssertNil(player.attributes[.drawOnSetTurn])
    }

    func test_pedroRamirezStartTurn_withAnotherPlayerHoldingCard_ShouldAskDrawFirstCardFromPlayer() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAttributes([.pedroRamirez: 0, .startTurnCards: 2])
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
        let action = GameAction.setTurn("p1")
        let (result, _) = self.awaitAction(action, choose: ["p2"], state: state)

        // Then
        XCTAssertEqual(result, [
            .setTurn("p1"),
            .chooseOne(player: "p1", options: [
                "p2": .stealHand("c2", target: "p2", player: "p1"),
                "p3": .stealHand("c3", target: "p3", player: "p1")
            ]),
            .stealHand("c2", target: "p2", player: "p1"),
            .draw(player: "p1")
        ])
    }

    func test_pedroRamirezStartTurn_withthoutAnotherPlayerHoldingCard_ShouldDrawCardsFromDeck() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAttributes([.pedroRamirez: 0, .startTurnCards: 2])
            }
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.setTurn("p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .setTurn("p1"),
            .draw(player: "p1"),
            .draw(player: "p1")
        ])
    }
}
