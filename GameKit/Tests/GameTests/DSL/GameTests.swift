//
//  GameTests.swift
//
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Foundation
import Game
import XCTest
// swiftlint:disable no_magic_numbers

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
        XCTAssertNil(sut.arena)
    }

    func test_buildGame_byDefault_shouldNotBeOver() throws {
        let sut = GameState.makeBuilder()
            .build()
        XCTAssertNil(sut.isOver)
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
        XCTAssertEqual(sut.arena?.cards, ["c1", "c2"])
    }

    func test_buildGame_withGameOver_shouldBeOver() throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withWinner("p1")
            .build()

        // Then
        XCTAssertEqual(sut.isOver, GameOver(winner: "p1"))
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
            .withCardRef(["name": Card("name")])
            .withChooseOne("p1", options: [:])
            .withSequence([.discover])
            .withPlayer("p1") {
                $0.withHealth(3)
            }
            .withPlayer("p2") {
                $0.withHealth(4)
                    .withAttributes([.bangsPerTurn: 2, "a1": 0])
                    .withHand(["c21", "c22"])
                    .withInPlay(["c23", "c24"])
            }
            .build()

        // Then
        XCTAssertEqual(state.turn, "p1")
        XCTAssertEqual(state.deck.cards, ["c1", "c2"])
        XCTAssertEqual(state.playedThisTurn["bang"], 1)
        XCTAssertEqual(state.discard.cards, ["c3", "c4"])
        XCTAssertEqual(state.arena?.cards, ["c5", "c6"])
        XCTAssertEqual(state.isOver?.winner, "p1")
        XCTAssertEqual(state.cardRef["name"], Card("name"))
        XCTAssertEqual(state.chooseOne?.chooser, "p1")
        XCTAssertEqual(state.sequence, [.discover])
        XCTAssertEqual(state.playOrder, ["p1", "p2"])

        XCTAssertNotNil(state.players["p1"])
        XCTAssertEqual(state.player("p1").health, 3)
        XCTAssertEqual(state.player("p1").attributes, [:])
        XCTAssertEqual(state.player("p1").hand.cards, [])
        XCTAssertEqual(state.player("p1").inPlay.cards, [])

        XCTAssertNotNil(state.players["p2"])
        XCTAssertEqual(state.player("p2").health, 4)
        XCTAssertEqual(state.player("p2").attributes[.bangsPerTurn], 2)
        XCTAssertEqual(state.player("p2").attributes["a1"], 0)
        XCTAssertEqual(state.player("p2").hand.cards, ["c21", "c22"])
        XCTAssertEqual(state.player("p2").inPlay.cards, ["c23", "c24"])
    }

    func test_game_shouldBeSerializable() throws {
        // Given
        let JSON = """
        {
          "isOver": {
             "winner": "p1"
          },
          "players": {
            "p1": {
              "id": "p1",
              "figure": "p1",
              "health": 3,
              "abilities": [],
              "attributes": {},
              "hand": {
                "hidden": true,
                "cards": []
              },
              "inPlay": {
                "hidden": false,
                "cards": []
              }
            }
          },
          "attributes": {},
          "abilities": [],
          "playOrder": [
            "p1"
          ],
          "startOrder": [
            "p1"
          ],
          "turn": "p1",
          "deck": {
            "cards": [
              "c1"
            ]
          },
          "discard": {
            "cards": [
              "c2"
            ]
          },
          "sequence": [],
          "playedThisTurn": {},
          "playMode": {},
          "cardRef": {},
        }
        """
        let jsonData = try XCTUnwrap(JSON.data(using: .utf8))

        // When
        let sut = try JSONDecoder().decode(GameState.self, from: jsonData)

        // Then
        XCTAssertEqual(sut.isOver, GameOver(winner: "p1"))
        XCTAssertNotNil(sut.players["p1"])
        XCTAssertEqual(sut.playOrder, ["p1"])
        XCTAssertEqual(sut.turn, "p1")
        XCTAssertEqual(sut.deck.count, 1)
        XCTAssertEqual(sut.discard.count, 1)
        XCTAssertNil(sut.arena)
    }
}
