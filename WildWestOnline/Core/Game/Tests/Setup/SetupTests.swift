//
//  SetupTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct SetupTests {
    @Test func setupDeck_shouldCreateCardsByCombiningNameAndValues() async throws {
        // Given
        let cardSets: [String: [String]] = [
            "card1": ["val11", "val12"],
            "card2": ["val21", "val22"]
        ]

        // When
        let deck = Setup.buildDeck(cardSets: cardSets)

        // Then
        #expect(deck.contains("card1-val11"))
        #expect(deck.contains("card1-val12"))
        #expect(deck.contains("card2-val21"))
        #expect(deck.contains("card2-val22"))
    }

    @Test func setupGame_shouldCreatePlayer() async throws {
        // Given
        let deck = Array(1...80).map { "c\($0)" }
        let figures = ["p1", "p2"]
        let cards: [String: Card] = [
            "p1": Card(name: "p1", playerAttributes: [.maxHealth: 4, .magnifying: 1]),
            "p2": Card(name: "p2", playerAttributes: [.maxHealth: 3, .remoteness: 1])
        ]

        // When
        let state = Setup.buildGame(
            figures: figures,
            deck: deck,
            cards: cards
        )

        // Then
        // should create a game with given player number
        #expect(state.players.count == 2)
        #expect(state.round.playOrder.contains(["p1", "p2"]))
        #expect(state.round.startOrder.contains(["p1", "p2"]))

        // should set players to max health
        #expect(state.player("p1").health == 4)
        #expect(state.player("p2").health == 3)

        // should set players hand cards to health
        #expect(state.field.hand["p1"]?.count == 4)
        #expect(state.field.hand["p2"]?.count == 3)
        #expect(state.field.deck.count == 73)
        #expect(state.field.discard.isEmpty)

        // should set undefined turn
        #expect(state.round.turn == nil)

        // should set figure attributes
        #expect(state.player("p1").abilities == ["p1"])
        #expect(state.player("p1").attributes[.magnifying] == 1)
        #expect(state.player("p1").attributes[.maxHealth] == 4)
        #expect(state.player("p2").abilities == ["p2"])
        #expect(state.player("p2").attributes[.remoteness] == 1)
        #expect(state.player("p2").attributes[.maxHealth] == 3)

        // should initialize inPlay field
        #expect(state.field.inPlay["p1"] != nil)
        #expect(state.field.inPlay["p2"] != nil)
    }
}
