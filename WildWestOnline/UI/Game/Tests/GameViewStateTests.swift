//
//  GameViewStateTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 25/03/2024.
//

import AppCore
import CardsData
import GameCore
@testable import GameUI
import Redux
import SettingsCore
import Testing

struct GameViewStateTests {
    @Test func state_shouldDisplayCurrentTurnPlayer() async throws {
        // Given
        let game = GameState.makeBuilder()
            .withTurn("p1")
            .withPlayModes(["p1": .manual])
            .withPlayer("p1")
            .build()
        let appState = AppState(
            navigation: .init(),
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build(),
            game: game
        )

        // When
        let result = try #require(GameView.presenter(appState))

        // Then
        #expect(result.message == "P1's turn")
    }

    @Test func state_shouldDisplayStatusForEachPlayers() async throws {
        // Given
        let game = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withFigure(.willyTheKid)
                    .withHealth(1)
                    .withAttributes([.maxHealth: 3])
            }
            .withPlayer("p2") {
                $0.withFigure(.bartCassidy)
                    .withHealth(3)
                    .withAttributes([.maxHealth: 4])
            }
            .withPlayModes(["p1": .manual])
            .withTurn("p1")
            .build()
        let appState = AppState(
            navigation: .init(),
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build(),
            game: game
        )

        // When
        let result = try #require(GameView.presenter(appState))

        // Then
        #expect(result.players.count == 2)

        let player1 = try #require(result.players[0])
        #expect(player1.id == "p1")
        #expect(player1.imageName == "willyTheKid")
        #expect(player1.displayName == "WILLYTHEKID")
        #expect(player1.health == 1)
        #expect(player1.maxHealth == 3)
        #expect(player1.handCount == 0)
        #expect(player1.inPlay == [])
        #expect(player1.isTurn)
        #expect(!player1.isEliminated)

        let player2 = try #require(result.players[1])
        #expect(player2.id == "p2")
        #expect(player2.imageName == "bartCassidy")
        #expect(player2.displayName == "BARTCASSIDY")
        #expect(player2.health == 3)
        #expect(player2.maxHealth == 4)
        #expect(player2.handCount == 0)
        #expect(player2.inPlay == [])
        #expect(!player2.isTurn)
        #expect(!player2.isEliminated)
    }

    @Test func state_shouldDisplayCardActions() async throws {
        // Given
        let game = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withFigure(.willyTheKid)
                    .withHealth(1)
                    .withAttributes([.maxHealth: 4])
                    .withAbilities([.endTurn, .willyTheKid])
                    .withHand([.bang, .gatling])
                    .withInPlay([.saloon, .barrel])
            }
            .withPlayer("p2")
            .withPlayModes(["p1": .manual])
            .withActive([.bang, .endTurn], player: "p1")
            .build()
        let appState = AppState(
            navigation: .init(),
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build(),
            game: game
        )

        // When
        let result = try #require(GameView.presenter(appState))

        // Then
        #expect(result.handCards == [
            .init(card: .bang, active: true),
            .init(card: .gatling, active: false),
            .init(card: .endTurn, active: true)
        ])
    }

    @Test func state_shouldDisplayChooseOneActions() async throws {
        // Given
        let game = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2")
            .withChooseOne(.cardToDraw, options: [.missed, .bang], player: "p1")
            .withPlayModes(["p1": .manual])
            .build()
        let appState = AppState(
            navigation: .init(),
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build(),
            game: game
        )

        // When
        let result = try #require(GameView.presenter(appState))

        // Then
        #expect(
            result.chooseOne ==
            GameView.State.ChooseOne(
                choiceType: ChoiceType.cardToDraw.rawValue,
                options: [.missed, .bang]
            )
        )
    }
}
