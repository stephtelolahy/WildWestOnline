//
//  GameTests.swift
//
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Foundation
import GameCore
import XCTest

final class GameTests: XCTestCase {
    func test_buildGame_byDefault_shouldHaveEmptyDeck() throws {
        let sut = GameState.makeBuilder()
            .build()
        XCTAssertEqual(sut.field.deck.count, 0)
    }

    func test_buildGame_byDefault_shouldHaveEmptyDiscard() throws {
        let sut = GameState.makeBuilder()
            .build()
        XCTAssertEqual(sut.field.discard.count, 0)
    }

    func test_buildGame_byDefault_shouldNotHaveDiscovered() throws {
        let sut = GameState.makeBuilder()
            .build()
        XCTAssertEqual(sut.field.discovered, [])
    }

    func test_buildGame_byDefault_shouldNotBeOver() throws {
        let sut = GameState.makeBuilder()
            .build()
        XCTAssertNil(sut.sequence.winner)
    }

    func test_buildGame_byDefault_shouldNotHaveTurn() throws {
        let sut = GameState.makeBuilder()
            .build()
        XCTAssertNil(sut.round.turn)
    }

    func test_buildGame_byDefault_shouldNotHavePlayers() throws {
        let sut = GameState.makeBuilder()
            .build()
        XCTAssertEqual(sut.players, [:])
    }

    func test_buildGame_withDeck_shouldHaveDeck() throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withDeck(["c1", "c2"])
            .build()

        // Then
        XCTAssertEqual(sut.field.deck.count, 2)
    }

    func test_buildGame_withDiscard_shouldHaveDiscard() throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withDiscard(["c1", "c2"])
            .build()

        // Then
        XCTAssertEqual(sut.field.discard.count, 2)
    }

    func test_buildGame_withDiscovered_shouldHaveDiscovered() throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withDiscovered(["c1", "c2"])
            .build()

        // Then
        XCTAssertEqual(sut.field.discovered, ["c1", "c2"])
    }

    func test_buildGame_withGameOver_shouldBeOver() throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withWinner("p1")
            .build()

        // Then
        XCTAssertEqual(sut.sequence.winner, "p1")
    }

    func test_buildGame_withTurn_shouldHaveTurn() throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withTurn("p1")
            .build()

        // Then
        XCTAssertEqual(sut.round.turn, "p1")
    }

    func test_buildGame_withSequence_shouldHaveSequence() throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withSequence([.drawDeck(player: "p1")])
            .build()

        // Then
        XCTAssertEqual(sut.sequence.queue, [
            .drawDeck(player: "p1")
        ])
    }

    func test_buildGame_withMultipleAttributes_shouldHaveAttributes() throws {
        // Given
        // When
        let state = GameState.makeBuilder()
            .withTurn("p1")
            .withDeck(["c1", "c2"])
            .withPlayedThisTurn(["bang": 1])
            .withDiscard(["c3", "c4"])
            .withDiscovered(["c5", "c6"])
            .withWinner("p1")
            .withCards(["name": Card(name: "name")])
            .withChooseOne(.cardToDraw, options: [], player: "p1")
            .withSequence([.discover(1)])
            .withPlayer("p1") {
                $0.withHealth(3)
            }
            .withPlayer("p2") {
                $0.withHealth(4)
                    .withAttributes([.weapon: 2])
                    .withAbilities(["a1"])
                    .withHand(["c21", "c22"])
                    .withInPlay(["c23", "c24"])
            }
            .build()

        // Then
        XCTAssertEqual(state.round.turn, "p1")
        XCTAssertEqual(state.field.deck, ["c1", "c2"])
        XCTAssertEqual(state.sequence.played["bang"], 1)
        XCTAssertEqual(state.field.discard, ["c3", "c4"])
        XCTAssertEqual(state.field.discovered, ["c5", "c6"])
        XCTAssertEqual(state.sequence.winner, "p1")
        XCTAssertNotNil(state.cards["name"])
        XCTAssertNotNil(state.sequence.chooseOne["p1"])
        XCTAssertEqual(state.sequence.queue, [.discover(1)])
        XCTAssertEqual(state.round.playOrder, ["p1", "p2"])

        XCTAssertNotNil(state.players["p1"])
        XCTAssertEqual(state.player("p1").health, 3)
        XCTAssertEqual(state.player("p1").attributes, [:])
        XCTAssertEqual(state.field.hand["p1"], [])
        XCTAssertEqual(state.field.inPlay["p1"], [])

        XCTAssertNotNil(state.players["p2"])
        XCTAssertEqual(state.player("p2").health, 4)
        XCTAssertEqual(state.player("p2").attributes[.weapon], 2)
        XCTAssertEqual(state.player("p2").abilities, ["a1"])
        XCTAssertEqual(state.field.hand["p2"], ["c21", "c22"])
        XCTAssertEqual(state.field.inPlay["p2"], ["c23", "c24"])
    }
}
