//
//  GameStateBuilderTests.swift
//
//
//  Created by Hugues Telolahy on 22/10/2023.
//

import XCTest
import Game

final class GameStateBuilderTests: XCTestCase {

    func test_BuildGame() {
        // Given
        // When
        let state = GameState.makeBuilder()
            .withTurn("p1")
            .withDeck("c1", "c2")
            .withPlayCounter("bang", value: 1)
            .withDiscard("c3", "c4")
            .withArena("c5", "c6")
            .withWinner("p1")
            .withCardRef(["name": Card("name")])
            .withChooseOne("p1", options: [:])
            .withQueue(GameAction.discover)
            .withPlayer("p1") {
                $0.withHealth(3)
            }
            .withPlayer("p2") {
                $0.withHealth(4)
                    .withAttributes([.bangsPerTurn: 2])
                    .withAbilities(["a1"])
                    .withHand(["c21", "c22"])
                    .withInPlay(["c23", "c24"])
            }
            .build()

        // Then
        XCTAssertEqual(state.turn, "p1")
        XCTAssertEqual(state.deck.cards, ["c1", "c2"])
        XCTAssertEqual(state.playCounter["bang"], 1)
        XCTAssertEqual(state.discard.cards, ["c3", "c4"])
        XCTAssertEqual(state.arena?.cards, ["c5", "c6"])
        XCTAssertEqual(state.isOver?.winner, "p1")
        XCTAssertEqual(state.cardRef["name"], Card("name"))
        XCTAssertEqual(state.chooseOne?.chooser, "p1")
        XCTAssertEqual(state.queue, [.discover])
        XCTAssertEqual(state.playOrder, ["p1", "p2"])

        XCTAssertNotNil(state.players["p1"])
        XCTAssertEqual(state.player("p1").health, 3)
        XCTAssertEqual(state.player("p1").abilities, [])
        XCTAssertEqual(state.player("p1").attributes, [:])
        XCTAssertEqual(state.player("p1").hand.cards, [])
        XCTAssertEqual(state.player("p1").inPlay.cards, [])

        XCTAssertNotNil(state.players["p2"])
        XCTAssertEqual(state.player("p2").health, 4)
        XCTAssertEqual(state.player("p2").attributes[.bangsPerTurn], 2)
        XCTAssertEqual(state.player("p2").abilities, ["a1"])
        XCTAssertEqual(state.player("p2").hand.cards, ["c21", "c22"])
        XCTAssertEqual(state.player("p2").inPlay.cards, ["c23", "c24"])

    }
}
