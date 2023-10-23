//
//  GameStateMakerTests.swift
//
//
//  Created by Hugues Telolahy on 22/10/2023.
//

import XCTest
import Game

final class GameStateMakerTests: XCTestCase {

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
            .withPlayer("p1", builderFunc: { builder in
                builder.withHealth(3)
            })
            .build()

        // Then
        XCTAssertEqual(state.turn, "p1")
        XCTAssertEqual(state.deck.cards, ["c1", "c2"])
        XCTAssertEqual(state.playCounter["bang"], 1)
        XCTAssertEqual(state.discard.cards, ["c3", "c4"])
        XCTAssertEqual(state.arena?.cards, ["c5", "c6"])
        XCTAssertEqual(state.isOver?.winner, "p1")
        XCTAssertEqual(state.cardRef["name"], Card("name"))
        XCTAssertEqual(state.chooseOne, ChooseOne(chooser: "p1", options: [:]))
        XCTAssertEqual(state.queue, [.discover])
    }
}
