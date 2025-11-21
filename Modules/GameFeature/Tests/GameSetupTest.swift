//
//  GameSetupTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
@testable import GameFeature

struct GameSetupTest {
    @Test func setupDeck_shouldCreateCardsByCombiningNameAndValues() async throws {
        // Given
        let cardSets: [String: [String]] = [
            "card1": ["val11", "val12"],
            "card2": ["val21", "val22"]
        ]

        // When
        let deck = GameSetup.buildDeck(deck: cardSets)

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
            "p1": .init(
                name: "p1",
                type: .figure,
                effects: [
                    .init(trigger: .permanent, action: .setMaxHealth, amount: 4),
                    .init(trigger: .permanent, action: .increaseMagnifying, amount: 1),
                    .init(trigger: .permanent, action: .setHandLimit, amount: 10)
                ]
            ),
            "p2": .init(
                name: "p2",
                type: .figure,
                effects: [
                    .init(trigger: .permanent, action: .setMaxHealth, amount: 3),
                    .init(trigger: .permanent, action: .increaseRemoteness, amount: 1)
                ]
            )
        ]

        // When
        let state = GameSetup.buildGame(
            figures: figures,
            deck: deck,
            cards: cards,
            auras: ["a1", "a2"]
        )

        // Then
        // should create a game with given player number
        #expect(state.players.count == 2)
        #expect(state.playOrder.contains(["p1", "p2"]))
        #expect(state.startOrder.contains(["p1", "p2"]))

        // should set players to max health
        #expect(state.players.get("p1").health == 4)
        #expect(state.players.get("p2").health == 3)

        // should set players hand cards to health
        #expect(state.players.get("p1").hand.count == 4)
        #expect(state.players.get("p2").hand.count == 3)

        // should set deck and discards
        #expect(state.deck.count == 73)
        #expect(state.discard.isEmpty)
        #expect(state.discovered.isEmpty)

        // should set undefined turn
        #expect(state.turn == nil)

        // should set auras
        #expect(state.auras == ["a1", "a2"])

        // should set figure attributes
        #expect(state.players.get("p1").figure == ["p1"])
        #expect(state.players.get("p1").magnifying == 1)
        #expect(state.players.get("p1").maxHealth == 4)
        #expect(state.players.get("p1").weapon == 1)
        #expect(state.players.get("p1").handLimit == 10)

        #expect(state.players.get("p2").figure == ["p2"])
        #expect(state.players.get("p2").remoteness == 1)
        #expect(state.players.get("p2").maxHealth == 3)
        #expect(state.players.get("p2").weapon == 1)
        #expect(state.players.get("p2").handLimit == 0)

        // should initialize inPlay field
        #expect(state.players.get("p1").inPlay.isEmpty)
        #expect(state.players.get("p2").inPlay.isEmpty)
    }
}
