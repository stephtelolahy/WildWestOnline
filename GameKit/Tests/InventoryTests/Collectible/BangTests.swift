//
//  BangTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Game
import XCTest

final class BangTests: XCTestCase {
    func test_playingBang_shouldDamageBy1() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .weapon: 1])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne([
                "p2": .effect(.shoot, ctx: .init(actor: "p1", card: .bang, event: action, target: "p2"))
            ], player: "p1"),
            .damage(1, player: "p2")
        ])
    }

    func test_playingBang_reachedLimitPerTurn_shouldThrowError() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.weapon: 1, .bangsPerTurn: 1])
            }
            .withPlayer("p2")
            .withPlayedThisTurn([.bang: 1])
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let (_, error) = self.awaitAction(action, state: state)

        // Assert
        XCTAssertEqual(error, .noReq(.isCardPlayedLessThan(.bang, .attr(.bangsPerTurn))))
    }

    func test_playingBang_noLimitPerTurn_shouldAllowMultipleBang() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.weapon: 1, .bangsPerTurn: 0])
            }
            .withPlayer("p2")
            .withPlayedThisTurn([.bang: 1])
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2"])

        // Assert
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne([
                "p2": .effect(.shoot, ctx: .init(actor: "p1", card: .bang, event: action, target: "p2"))
            ], player: "p1"),
            .damage(1, player: "p2")
        ])
    }

    func test_playingBang_noPlayerReachable_shouldThrowError() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .weapon: 1])
            }
            .withPlayer("p2") {
                $0.withAttributes([.mustang: 1])
            }
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let (_, error) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(error, .noPlayer(.selectReachable))
    }
}
