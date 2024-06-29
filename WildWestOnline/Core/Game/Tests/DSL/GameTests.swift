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
        XCTAssertEqual(sut.deck.count, 0)
    }

    func test_buildGame_byDefault_shouldHaveEmptyDiscard() throws {
        let sut = GameState.makeBuilder()
            .build()
        XCTAssertEqual(sut.discard.count, 0)
    }

    func test_buildGame_byDefault_shouldNotHaveArena() throws {
        let sut = GameState.makeBuilder()
            .build()
        XCTAssertEqual(sut.arena, [])
    }

    func test_buildGame_byDefault_shouldNotBeOver() throws {
        let sut = GameState.makeBuilder()
            .build()
        XCTAssertNil(sut.winner)
    }

    func test_buildGame_byDefault_shouldNotHaveTurn() throws {
        let sut = GameState.makeBuilder()
            .build()
        XCTAssertNil(sut.turn)
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
        XCTAssertEqual(sut.deck.count, 2)
    }

    func test_buildGame_withDiscard_shouldHaveDiscard() throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withDiscard(["c1", "c2"])
            .build()

        // Then
        XCTAssertEqual(sut.discard.count, 2)
    }

    func test_buildGame_withArena_shouldHaveArena() throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withArena(["c1", "c2"])
            .build()

        // Then
        XCTAssertEqual(sut.arena, ["c1", "c2"])
    }

    func test_buildGame_withGameOver_shouldBeOver() throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withWinner("p1")
            .build()

        // Then
        XCTAssertEqual(sut.winner, "p1")
    }

    func test_buildGame_withTurn_shouldHaveTurn() throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withTurn("p1")
            .build()

        // Then
        XCTAssertEqual(sut.turn, "p1")
    }

    func test_buildGame_withSequence_shouldHaveSequence() throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withSequence([.drawDeck(player: "p1")])
            .build()

        // Then
        XCTAssertEqual(sut.sequence, [
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
            .withArena(["c5", "c6"])
            .withWinner("p1")
            .withCards(["name": Card.makeBuilder(name: "name").build()])
            .withChooseOne(.cardToDraw, options: [], player: "p1")
            .withSequence([.discover])
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
        XCTAssertEqual(state.turn, "p1")
        XCTAssertEqual(state.deck, ["c1", "c2"])
        XCTAssertEqual(state.playedThisTurn["bang"], 1)
        XCTAssertEqual(state.discard, ["c3", "c4"])
        XCTAssertEqual(state.arena, ["c5", "c6"])
        XCTAssertEqual(state.winner, "p1")
        XCTAssertNotNil(state.cards["name"])
        XCTAssertNotNil(state.chooseOne["p1"])
        XCTAssertEqual(state.sequence, [.discover])
        XCTAssertEqual(state.playOrder, ["p1", "p2"])

        XCTAssertNotNil(state.players["p1"])
        XCTAssertEqual(state.playerState("p1").health, 3)
        XCTAssertEqual(state.player("p1").attributes, [:])
        XCTAssertEqual(state.player("p1").hand, [])
        XCTAssertEqual(state.player("p1").inPlay, [])

        XCTAssertNotNil(state.players["p2"])
        XCTAssertEqual(state.playerState("p2").health, 4)
        XCTAssertEqual(state.player("p2").attributes[.weapon], 2)
        XCTAssertEqual(state.player("p2").abilities, ["a1"])
        XCTAssertEqual(state.player("p2").hand, ["c21", "c22"])
        XCTAssertEqual(state.player("p2").inPlay, ["c23", "c24"])
    }
}
