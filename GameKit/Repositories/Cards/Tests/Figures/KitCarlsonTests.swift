//
//  KitCarlsonTests.swift
//
//
//  Created by Hugues Telolahy on 18/11/2023.
//
// swiftlint:disable no_magic_numbers

import GameCore
import CardsRepository
import XCTest

final class KitCarlsonTests: XCTestCase {
    func test_kitCarlson_shouldHaveSpecialStartTurn() throws {
        // Given
        let state = Setup.buildGame(figures: [.kitCarlson], deck: [], cardRef: CardList.all)

        // When
        let player = state.player(.kitCarlson)

        // Then
        XCTAssertFalse(player.abilities.contains(.drawOnSetTurn))
    }

    func test_kitCarlsonStartTurn_withEnoughDeckCards_shouldChooseDeckCards() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAbilities([.kitCarlson])
                    .withAttributes([.startTurnCards: 2])
                    .withHand(["c0"])
            }
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameAction.setTurn(player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["c2"])

        // Then
        XCTAssertEqual(result, [
            .setTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .chooseOne(.card, options: ["c1", "c2", "c3"], player: "p1"),
            .choose("c2", player: "p1"),
            .putBack("c2", player: "p1")
        ])
    }

    func test_kitCarlsonStartTurn_withoutEnoughDeckCards_shouldChooseDeckCards() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAbilities([.kitCarlson])
                    .withAttributes([.startTurnCards: 2])
            }
            .withDeck(["c1", "c2"])
            .withDiscard(["c3", "c3"])
            .build()

        // When
        let action = GameAction.setTurn(player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["c2"])

        // Then
        XCTAssertEqual(result, [
            .setTurn(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .chooseOne(.card, options: ["c1", "c2", "c3"], player: "p1"),
            .choose("c2", player: "p1"),
            .putBack("c2", player: "p1")
        ])
    }
}
