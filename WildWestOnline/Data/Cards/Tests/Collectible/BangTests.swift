//
//  BangTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class BangTests: XCTestCase {
    func test_playingBang_shouldDamageBy1() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .weapon: 1])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
            .damage(1, player: "p2")
        ])
    }

    func test_playingBang_reachedLimitPerTurn_shouldThrowError() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.weapon: 1, .bangsPerTurn: 1])
            }
            .withPlayer("p2")
            .withPlayedThisTurn([.bang: 1])
            .build()

        // When
        // Assert
        let action = GameAction.play(.bang, player: "p1")
        XCTAssertThrowsError(try awaitAction(action, state: state)) { error in
            XCTAssertEqual(error as? PlayReq.Error, .noReq(.isCardPlayedLessThan(.bang, .attr(.bangsPerTurn))))
        }
    }

    func test_playingBang_noLimitPerTurn_shouldAllowMultipleBang() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.weapon: 1, .bangsPerTurn: 0])
            }
            .withPlayer("p2")
            .withPlayedThisTurn([.bang: 1])
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2"])

        // Assert
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
            .damage(1, player: "p2")
        ])
    }

    func test_playingBang_noPlayerReachable_shouldThrowError() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .weapon: 1])
            }
            .withPlayer("p2") {
                $0.withAttributes([.remoteness: 1])
            }
            .build()

        // When
        // Then
        let action = GameAction.play(.bang, player: "p1")
        XCTAssertThrowsError(try awaitAction(action, state: state)) { error in
            XCTAssertEqual(error as? ArgPlayer.Error, .noPlayer(.selectReachable))
        }
    }
}
