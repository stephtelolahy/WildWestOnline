//
//  GamePlayStateTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 23/01/2024.
//

import AppCore
import CardNames
import GameCore
import GamePlay
import XCTest

final class GamePlayStateTests: XCTestCase {
    func test_state_shouldDisplayCurrentTurnPlayer() throws {
        // Given
        let game = GameState.makeBuilder()
            .withTurn("p1")
            .build()
        let appState = AppState(screens: [], settings: .init(), game: game)

        // When
        let result = try XCTUnwrap(GamePlayView.State.from(globalState: appState))

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
        let appState = AppState(screens: [], settings: .init(), game: game)

        // When
        let result = try XCTUnwrap(GamePlayView.State.from(globalState: appState))

        // Then
        XCTAssertEqual(result.visiblePlayers.count, 2)

        let player1 = try XCTUnwrap(result.visiblePlayers[0])
        XCTAssertEqual(player1.id, "p1")
        XCTAssertEqual(player1.imageName, "willyTheKid")
        XCTAssertEqual(player1.status, .active)

        let player2 = try XCTUnwrap(result.visiblePlayers[1])
        XCTAssertEqual(player2.id, "p2")
        XCTAssertEqual(player2.imageName, "bartCassidy")
        XCTAssertEqual(player2.status, .idle)
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
        let appState = AppState(screens: [], settings: .init(), game: game)

        // When
        let result = try XCTUnwrap(GamePlayView.State.from(globalState: appState))

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
            .withChooseOne(.card, options: [.missed, .bang], player: "p1")
            .withPlayModes(["p1": .manual])
            .build()
        let appState = AppState(screens: [], settings: .init(), game: game)

        // When
        let result = try XCTUnwrap(GamePlayView.State.from(globalState: appState))

        // Then
        XCTAssertEqual(result.chooseOneActions, [
            .missed: .choose(.missed, player: "p1"),
            .bang: .choose(.bang, player: "p1")
        ])
    }
}
