//
//  GamePlayViewStateTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 25/03/2024.
//

import AppCore
import CardsRepository
import GameCore
import GamePlay
import Redux
import SettingsCore
import XCTest

final class GamePlayViewStateTests: XCTestCase {
    func test_state_shouldDisplayCurrentTurnPlayer() throws {
        // Given
        let game = GameState.makeBuilder()
            .withTurn("p1")
            .build()
        let appState = AppState(
            screens: [],
            settings: SettingsState.makeBuilder().build(),
            game: game
        )
        let sut = Connectors.GamePlayViewConnector()

        // When
        let result = try XCTUnwrap(sut.connect(state: appState))

        // Then
        XCTAssertEqual(result.message, "P1's turn")
    }

    func test_state_shouldDisplayStatusForEachPlayers() throws {
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
            screens: [],
            settings: SettingsState.makeBuilder().build(),
            game: game
        )
        let sut = Connectors.GamePlayViewConnector()

        // When
        let result = try XCTUnwrap(sut.connect(state: appState))

        // Then
        XCTAssertEqual(result.players.count, 2)

        let player1 = try XCTUnwrap(result.players[0])
        XCTAssertEqual(player1.id, "p1")
        XCTAssertEqual(player1.imageName, "willyTheKid")
        XCTAssertEqual(player1.displayName, "WILLYTHEKID")
        XCTAssertEqual(player1.health, 1)
        XCTAssertEqual(player1.maxHealth, 3)
        XCTAssertEqual(player1.handCount, 0)
        XCTAssertEqual(player1.inPlay, [])
        XCTAssertTrue(player1.isTurn)
        XCTAssertFalse(player1.isEliminated)

        let player2 = try XCTUnwrap(result.players[1])
        XCTAssertEqual(player2.id, "p2")
        XCTAssertEqual(player2.imageName, "bartCassidy")
        XCTAssertEqual(player2.displayName, "BARTCASSIDY")
        XCTAssertEqual(player2.health, 3)
        XCTAssertEqual(player2.maxHealth, 4)
        XCTAssertEqual(player2.handCount, 0)
        XCTAssertEqual(player2.inPlay, [])
        XCTAssertFalse(player2.isTurn)
        XCTAssertFalse(player2.isEliminated)
    }

    func test_state_shouldDisplayCardActions() throws {
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
            screens: [],
            settings: SettingsState.makeBuilder().build(),
            game: game
        )
        let sut = Connectors.GamePlayViewConnector()

        // When
        let result = try XCTUnwrap(sut.connect(state: appState))

        // Then
        XCTAssertEqual(result.handActions, [
            .init(card: .bang, action: .play(.bang, player: "p1")),
            .init(card: .gatling, action: nil),
            .init(card: .endTurn, action: .play(.endTurn, player: "p1"))
        ])
    }

    func test_state_shouldDisplayChooseOneActions() throws {
        // Given
        let game = GameState.makeBuilder()
            .withPlayer("p1")
            .withPlayer("p2")
            .withChooseOne(.cardToDraw, options: [.missed, .bang], player: "p1")
            .withPlayModes(["p1": .manual])
            .build()
        let appState = AppState(
            screens: [],
            settings: SettingsState.makeBuilder().build(),
            game: game
        )
        let sut = Connectors.GamePlayViewConnector()

        // When
        let result = try XCTUnwrap(sut.connect(state: appState))

        // Then
        XCTAssertEqual(
            result.chooseOneData,
            GamePlayView.State.ChooseOneData(
                choiceType: .cardToDraw,
                options: [.missed, .bang],
                actions: [
                    .missed: .choose(.missed, player: "p1"),
                    .bang: .choose(.bang, player: "p1")
                ]
            )
        )
    }
}
