//
//  GameViewTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 25/03/2024.
//

@testable import GameUI
import Testing
import AppFeature
import CardResources
import GameFeature
import SettingsFeature

struct GameViewTest {
    @Test func shouldDisplayCurrentTurnPlayer() async throws {
        // Given
        let game = GameFeature.State.makeBuilder()
            .withTurn("p1")
            .withPlayMode(["p1": .manual])
            .withPlayer("p1")
            .build()
        let appState = AppFeature.State(
            cardLibrary: .init(),
            navigation: .init(),
            settings: SettingsFeature.State.makeBuilder().build(),
            game: game
        )

        // When
        let viewState = try #require(GameView.ViewState(appState: appState))

        // Then
        #expect(viewState.message == "P1's turn")
    }

    @Test func shouldDisplayStatusForEachPlayers() async throws {
        // Given
        let game = GameFeature.State.makeBuilder()
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
        let appState = AppFeature.State(
            cardLibrary: .init(),
            navigation: .init(),
            settings: SettingsFeature.State.makeBuilder().build(),
            game: game
        )

        // When
        let viewState = try #require(GameView.ViewState(appState: appState))

        // Then
        #expect(viewState.players.count == 2)

        let player1 = viewState.players[0]
        #expect(player1.id == "p1")
        #expect(player1.imageName == "willyTheKid")
        #expect(player1.displayName == "WILLYTHEKID")
        #expect(player1.health == 1)
        #expect(player1.maxHealth == 3)
        #expect(player1.handCount == 0)
        #expect(player1.inPlay.isEmpty)
        #expect(player1.isTurn)
        #expect(!player1.isEliminated)

        let player2 = viewState.players[1]
        #expect(player2.id == "p2")
        #expect(player2.imageName == "paulRegret")
        #expect(player2.displayName == "PAULREGRET")
        #expect(player2.health == 3)
        #expect(player2.maxHealth == 4)
        #expect(player2.handCount == 0)
        #expect(player2.inPlay.isEmpty)
        #expect(!player2.isTurn)
        #expect(!player2.isEliminated)
    }

    @Test func shouldDisplayCardActions() async throws {
        // Given
        let game = GameFeature.State.makeBuilder()
            .withPlayer("p1") {
                $0.withFigure(.willyTheKid)
                    .withHealth(1)
                    .withMaxHealth(4)
                    .withAbilities([.endTurn, .willyTheKid])
                    .withHand([.bang, .gatling])
                    .withInPlay([.saloon, .barrel])
            }
            .withPlayer("p2")
            .withPlayMode(["p1": .manual])
            .withActive(["p1": [.bang, .endTurn]])
            .build()
        let appState = AppFeature.State(
            cardLibrary: .init(),
            navigation: .init(),
            settings: SettingsFeature.State.makeBuilder().build(),
            game: game
        )

        // When
        let viewState = try #require(GameView.ViewState(appState: appState))

        // Then
        #expect(viewState.handCards == [
            .init(card: .bang, active: true),
            .init(card: .gatling, active: false),
            .init(card: .endTurn, active: true)
        ])
    }

    @Test func shouldDisplayChooseOneActions() async throws {
        // Given
        let game = GameFeature.State.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2")
            .withPendingAction(
                name: .counterShot,
                prompt: .init(
                    chooser: "p1",
                    options: [
                        .init(id: .missed, label: .missed),
                        .init(id: .bang, label: .bang)
                    ]
                )
            )
            .withPlayMode(["p1": .manual])
            .build()
        let appState = AppFeature.State(
            cardLibrary: .init(),
            navigation: .init(),
            settings: SettingsFeature.State.makeBuilder().build(),
            game: game
        )

        // When
        let viewState = try #require(GameView.ViewState(appState: appState))

        // Then
        let chooseOne = try #require(viewState.chooseOne)
        #expect(chooseOne.options == [.missed, .bang])
        #expect(chooseOne.chooser == "p1")
        #expect(chooseOne.resolvingAction == .counterShot)
    }
}
