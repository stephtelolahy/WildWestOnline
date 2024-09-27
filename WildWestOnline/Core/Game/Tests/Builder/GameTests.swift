//
//  GameTests.swift
//
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Foundation
import GameCore
import Testing

struct GameTests {
    @Test func buildGame_byDefault_shouldHaveEmptyDeck() async throws {
        let sut = GameState.makeBuilder()
            .build()
        #expect(sut.deck.isEmpty)
    }

    @Test func buildGame_byDefault_shouldHaveEmptyDiscard() async throws {
        let sut = GameState.makeBuilder()
            .build()
        #expect(sut.discard.isEmpty)
    }

    @Test func buildGame_byDefault_shouldNotHaveDiscovered() async throws {
        let sut = GameState.makeBuilder()
            .build()
        #expect(sut.discovered.isEmpty)
    }

    @Test func buildGame_byDefault_shouldNotBeOver() async throws {
        let sut = GameState.makeBuilder()
            .build()
        #expect(sut.winner == nil)
    }

    @Test func buildGame_byDefault_shouldNotHaveTurn() async throws {
        let sut = GameState.makeBuilder()
            .build()
        #expect(sut.turn == nil)
    }

    @Test func buildGame_byDefault_shouldNotHavePlayers() async throws {
        let sut = GameState.makeBuilder()
            .build()
        #expect(sut.players.isEmpty)
    }

    @Test func buildGame_withDeck_shouldHaveDeck() async throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withDeck(["c1", "c2"])
            .build()

        // Then
        #expect(sut.deck.count == 2)
    }

    @Test func buildGame_withDiscard_shouldHaveDiscard() async throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withDiscard(["c1", "c2"])
            .build()

        // Then
        #expect(sut.discard.count == 2)
    }

    @Test func buildGame_withDiscovered_shouldHaveDiscovered() async throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withDiscovered(["c1", "c2"])
            .build()

        // Then
        #expect(sut.discovered == ["c1", "c2"])
    }

    @Test func buildGame_withGameOver_shouldBeOver() async throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withWinner("p1")
            .build()

        // Then
        #expect(sut.winner == "p1")
    }

    @Test func buildGame_withTurn_shouldHaveTurn() async throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withTurn("p1")
            .build()

        // Then
        #expect(sut.turn == "p1")
    }

    @Test func buildGame_withSequence_shouldHaveSequence() async throws {
        // Given
        // When
        let sut = GameState.makeBuilder()
            .withSequence([.drawDeck(player: "p1")])
            .build()

        // Then
        #expect(sut.queue == [
            .drawDeck(player: "p1")
        ])
    }

    @Test func buildGame_withMultipleAttributes_shouldHaveAttributes() async throws {
        // Given
        // When
        let state = GameState.makeBuilder()
            .withTurn("p1")
            .withDeck(["c1", "c2"])
            .withTurnPlayedBang(1)
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
                    .withWeapon(2)
                    .withAbilities(["a1"])
                    .withHand(["c21", "c22"])
                    .withInPlay(["c23", "c24"])
            }
            .build()

        // Then
        #expect(state.turn == "p1")
        #expect(state.deck == ["c1", "c2"])
        #expect(state.turnPlayedBang == 1)
        #expect(state.discard == ["c3", "c4"])
        #expect(state.discovered == ["c5", "c6"])
        #expect(state.winner == "p1")
        #expect(state.cards["name"] != nil)
        #expect(state.chooseOne["p1"] != nil)
        #expect(state.queue == [.discover(1)])
        #expect(state.playOrder == ["p1", "p2"])

        #expect(state.players["p1"] != nil)
        #expect(state.player("p1").health == 3)
        #expect(state.player("p1").hand.isEmpty)
        #expect(state.player("p1").inPlay.isEmpty)

        #expect(state.players["p2"] != nil)
        #expect(state.player("p2").health == 4)
        #expect(state.player("p2").weapon == 2)
        #expect(state.player("p2").abilities == ["a1"])
        #expect(state.player("p2").hand == ["c21", "c22"])
        #expect(state.player("p2").inPlay == ["c23", "c24"])
    }
}
