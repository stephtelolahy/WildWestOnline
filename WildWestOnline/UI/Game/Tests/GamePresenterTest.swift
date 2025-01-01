//
//  GamePresenterTest.swift
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

struct GamePresenterTest {
    @Test func shouldDisplayCurrentTurnPlayer() async throws {
        // Given
        let game = GameState.makeBuilder()
            .withTurn("p1")
            .withPlayMode(["p1": .manual])
            .withPlayer("p1")
            .build()
        let appState = AppState(
            navigation: .init(),
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build(),
            game: game
        )

        // When
        let result = try #require(await GameView.presenter(appState))

        // Then
        #expect(result.message == "P1's turn")
    }

    @Test func shouldDisplayStatusForEachPlayers() async throws {
        // Given
        let game = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withFigure(.willyTheKid)
                    .withHealth(1)
                    .withMaxHealth(3)
            }
            .withPlayer("p2") {
                $0.withFigure(.paulRegret)
                    .withHealth(3)
                    .withMaxHealth(4)
            }
            .withPlayMode(["p1": .manual])
            .withTurn("p1")
            .build()
        let appState = AppState(
            navigation: .init(),
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build(),
            game: game
        )

        // When
        let result = try #require(await GameView.presenter(appState))

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
        #expect(player2.imageName == "paulRegret")
        #expect(player2.displayName == "PAULREGRET")
        #expect(player2.health == 3)
        #expect(player2.maxHealth == 4)
        #expect(player2.handCount == 0)
        #expect(player2.inPlay == [])
        #expect(!player2.isTurn)
        #expect(!player2.isEliminated)
    }

    @Test func shouldDisplayCardActions() async throws {
        // Given
        let game = GameState.makeBuilder()
            .withPlayer("p1") {
                $0.withFigure(.willyTheKid)
                    .withHealth(1)
                    .withMaxHealth(4)
                    .withAbilities([.defaultEndTurn, .willyTheKid])
                    .withHand([.bang, .gatling])
                    .withInPlay([.saloon, .barrel])
            }
            .withPlayer("p2")
            .withPlayMode(["p1": .manual])
            .withActive(["p1": [.bang, .defaultEndTurn]])
            .build()
        let appState = AppState(
            navigation: .init(),
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build(),
            game: game
        )

        // When
        let result = try #require(await GameView.presenter(appState))

        // Then
        #expect(result.handCards == [
            .init(card: .bang, active: true),
            .init(card: .gatling, active: false),
            .init(card: .defaultEndTurn, active: true)
        ])
    }

    @Test func shouldDisplayChooseOneActions() async throws {
        // Given
        let game = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2")
            .withPendingChoice(
                .init(
                    chooser: "p1",
                    options: [
                        .init(value: .missed, label: .missed),
                        .init(value: .bang, label: .bang)
                    ]
                )
            )
            .withPlayMode(["p1": .manual])
            .build()
        let appState = AppState(
            navigation: .init(),
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build(),
            game: game
        )

        // When
        let result = try #require(await GameView.presenter(appState))

        // Then
        #expect(result.chooseOne ==
            GameView.State.ChooseOne(
                choiceType: "Unknown",
                options: [.missed, .bang]
            )
        )
    }
}
