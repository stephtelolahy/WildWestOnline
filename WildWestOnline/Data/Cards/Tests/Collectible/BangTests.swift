//
//  BangTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct BangTests {
    /*
    @Test func playingBang_shouldDamageBy1() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .weapon: 1])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.preparePlay(.bang, player: "p1")
        let result = try await dispatch(action, state: state, choose: ["p2"])

        // Then
        #expect(result == [
            .playBrown(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .damage(1, player: "p2")
        ])
    }

    @Test func playingBang_reachedLimitPerTurn_shouldThrowError() async throws {
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
        let action = GameAction.preparePlay(.bang, player: "p1")
        XCTAssertThrowsError(try awaitAction(action, state: state)) { error in
            #expect(error as? PlayReq.Error == .noReq(.isCardPlayedLessThan(.bang, .attr(.bangsPerTurn))))
        }
    }

    @Test func playingBang_noLimitPerTurn_shouldAllowMultipleBang() async throws {
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
        let action = GameAction.preparePlay(.bang, player: "p1")
        let result = try await dispatch(action, state: state, choose: ["p2"])

        // Assert
        #expect(result == [
            .playBrown(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .damage(1, player: "p2")
        ])
    }

    @Test func playingBang_noPlayerReachable_shouldThrowError() async throws {
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
        let action = GameAction.preparePlay(.bang, player: "p1")
        XCTAssertThrowsError(try awaitAction(action, state: state)) { error in
            #expect(error as? ArgPlayer.Error == .noPlayer(.selectReachable))
        }
    }
     */
}
