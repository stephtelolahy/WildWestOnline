//
//  MissedTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 12/10/2023.
//

import GameCore
import XCTest

final class MissedTests: XCTestCase {
    func test_beingShot_holdingMissedCard_shouldAskToCounter() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .missesRequiredForBang: 1, .weapon: 1])
            }
            .withPlayer("p2") {
                $0.withHand([.missed])
                    .withAbilities([.playCounterCardsOnShot])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.bang, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2", .missed])

        // Then
        XCTAssertEqual(
            result,
            [
                .playBrown(.bang, player: "p1"),
                .chooseOne(.target, options: ["p2"], player: "p1"),
                .chooseOne(.cardToPlayCounter, options: [.missed, .pass], player: "p2"),
                .playBrown(.missed, player: "p2")
            ]
        )
    }

    func test_beingShot_withoutMissedCard_shouldNotAskToCounter() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .missesRequiredForBang: 1, .weapon: 1])
            }
            .withPlayer("p2") {
                $0.withAbilities([.playCounterCardsOnShot])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.bang, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .playBrown(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .damage(1, player: "p2")
        ])
    }

    func test_beingShot_holdingMissedCards_shouldAskToCounter() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .missesRequiredForBang: 1, .weapon: 1])
            }
            .withPlayer("p2") {
                $0.withHand([.missed1, .missed2])
                    .withAbilities([.playCounterCardsOnShot])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.bang, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2", .missed2])

        // Then
        XCTAssertEqual(result, [
            .playBrown(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .chooseOne(.cardToPlayCounter, options: [.missed1, .missed2, .pass], player: "p2"),
            .playBrown(.missed2, player: "p2")
        ])
    }

    func test_playMissed_withoutBeingShoot_shouldThrowError() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.missed])
            }
            .withTurn("p1")
            .build()

        // When
        // Then
        let action = GameAction.preparePlay(.missed, player: "p1")
        XCTAssertThrowsError(try awaitAction(action, state: state)) { error in
            XCTAssertEqual(error as? SequenceState.Error, .noShootToCounter)
        }
    }
}

private extension String {
    static let missed1 = "\(String.missed)-1"
    static let missed2 = "\(String.missed)-2"
}
