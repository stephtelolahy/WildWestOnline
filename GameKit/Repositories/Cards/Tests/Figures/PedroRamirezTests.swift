//
//  PedroRamirezTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 13/11/2023.
//

import CardsRepository
import GameCore
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

    func test_pedroRamirezStartTurn_withAnotherPlayerHoldingCard_shouldAskDrawFirstCardFromPlayerThenDraw() throws {
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
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2", "hiddenHand-0"])

        // Then
        XCTAssertEqual(result, [
            .setTurn(player: "p1"),
            .chooseOne(.target, options: ["p2", "p3", .pass], player: "p1"),
            .choose("p2", player: "p1"),
            .chooseOne(.card, options: ["hiddenHand-0"], player: "p1"),
            .choose("hiddenHand-0", player: "p1"),
            .drawHand("c2", target: "p2", player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    func test_pedroRamirezStartTurn_withAnotherPlayerHoldingCard_shouldAskDrawFirstCardFromPlayerThenIgnore() throws {
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
            .withDeck(["c1", "c2"])
            .build()

        // When
        let action = GameAction.setTurn(player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: [.pass])

        // Then
        XCTAssertEqual(result, [
            .setTurn(player: "p1"),
            .chooseOne(.target, options: ["p2", "p3", .pass], player: "p1"),
            .choose(.pass, player: "p1"),
            .drawDeck(player: "p1"),
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
