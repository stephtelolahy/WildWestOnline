//
//  BangTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import Bang

struct BangTest {
    @Test func play_shouldDamageBy1() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2"], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .play(.bang, player: "p1"),
            .choose("p2", player: "p1"),
            .shoot("p2", player: "p1"),
            .damage(1, player: "p2")
        ])
    }

    @Test func play_reachedLimitPerTurn_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2")
            .withPlayedThisTurn([.bang: 1])
            .build()

        // When
        // Assert
        let action = GameAction.play(.bang, player: "p1")
        #expect(throws: GameError.noReq(.cardPlayedLessThan(1))) {
            try GameReducer().reduce(state, action)
        }
    }
    /*
    func play_noLimitPerTurn_shouldAllowMultipleBang() async throws {
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
        let result = try awaitAction(action, state: state, choose: ["p2"])

        // Assert
        XCTAssertEqual(result, [
            .playBrown(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .damage(1, player: "p2")
        ])
    }

    func play_noPlayerReachable_shouldThrowError() async throws {
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
            XCTAssertEqual(error as? ArgPlayer.Error, .noPlayer(.selectReachable))
        }
    }
 */
}
