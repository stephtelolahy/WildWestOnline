//
//  KitCarlsonTests.swift
//
//
//  Created by Hugues Telolahy on 18/11/2023.
//
// swiftlint:disable no_magic_numbers

import Game
import Inventory
import XCTest

final class KitCarlsonTests: XCTestCase {
    func test_kitCarlson_shouldHaveSpecialStartTurn() throws {
        // Given
        let state = Setup.buildGame(figures: [.kitCarlson], deck: [], cardRef: CardList.all)

        // When
        let player = state.player(.kitCarlson)

        // Then
        XCTAssertNil(player.attributes[.drawOnSetTurn])
    }

    func test_kitCarlsonStartTurn_shouldChooseDeckCards() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAttributes([.kitCarlson: 0, .startTurnCards: 2])
            }
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameAction.setTurn("p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["c2", "c3"])

        // Then
        XCTAssertEqual(result, [
            .setTurn("p1"),
            .chooseOne(player: "p1", options: [
                "c1": .drawDeckChoose("c1", player: "p1"),
                "c2": .drawDeckChoose("c2", player: "p1"),
                "c3": .drawDeckChoose("c3", player: "p1")
            ]),
            .drawDeckChoose("c2", player: "p1"),
            .chooseOne(player: "p1", options: [
                "c1": .drawDeckChoose("c1", player: "p1"),
                "c3": .drawDeckChoose("c3", player: "p1")
            ]),
            .drawDeckChoose("c3", player: "p1")
        ])
    }
}
