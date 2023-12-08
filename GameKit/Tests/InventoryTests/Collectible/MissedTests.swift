//
//  MissedTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 12/10/2023.
//

import Game
import XCTest

final class MissedTests: XCTestCase {
    func test_playMissed_withoutBeingShoot_shouldThrowError() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.missed])
            }
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.play(.missed, player: "p1")
        let (_, error) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(error, .noShootToCounter)
    }

    func test_beingShot_holdingMissedCard_shouldAskToCounter() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .weapon: 1])
            }
            .withPlayer("p2") {
                $0.withHand([.missed])
                    .withAbilities([.activateCounterCardsOnShot])
            }
            .build()

        // When
        let action = GameAction.playImmediate(.bang, target: "p2", player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: [.missed])

        // Then
        XCTAssertEqual(result, [
            .playImmediate(.bang, target: "p2", player: "p1"),
            .chooseOne(player: "p2", options: [
                .missed: .playImmediate(.missed, player: "p2"),
                .pass: .nothing
            ]),
            .playImmediate(.missed, player: "p2"),
            .cancel(.damage(1, player: "p2"))
        ])
    }

    func test_beingShot_holdingMissedCards_shouldAskToCounter() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .weapon: 1])
            }
            .withPlayer("p2") {
                $0.withHand([.missed1, .missed2])
                    .withAbilities([.activateCounterCardsOnShot])
            }
            .build()

        // When
        let action = GameAction.playImmediate(.bang, target: "p2", player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: [.missed2])

        // Then
        XCTAssertEqual(result, [
            .playImmediate(.bang, target: "p2", player: "p1"),
            .chooseOne(player: "p2", options: [
                .missed1: .playImmediate(.missed1, player: "p2"),
                .missed2: .playImmediate(.missed2, player: "p2"),
                .pass: .nothing
            ]),
            .playImmediate(.missed2, player: "p2"),
            .cancel(.damage(1, player: "p2"))
        ])
    }

    func test_multiplePlayersBeingShot_holdingMissedCard_shouldAskToCounter() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.gatling])
            }
            .withPlayer("p2") {
                $0.withHand([.missed])
                    .withAbilities([.activateCounterCardsOnShot])
            }
            .withPlayer("p3") {
                $0.withHand([.missed])
                    .withAbilities([.activateCounterCardsOnShot])
            }
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameAction.play(.gatling, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: [.missed, .missed])

        // Then
        XCTAssertEqual(result, [
            .playImmediate(.gatling, player: "p1"),
            .chooseOne(player: "p2", options: [
                .missed: .playImmediate(.missed, player: "p2"),
                .pass: .nothing
            ]),
            .playImmediate(.missed, player: "p2"),
            .cancel(.damage(1, player: "p2")),
            .chooseOne(player: "p3", options: [
                .missed: .playImmediate(.missed, player: "p3"),
                .pass: .nothing
            ]),
            .playImmediate(.missed, player: "p3"),
            .cancel(.damage(1, player: "p3"))
        ])
    }
}

private extension String {
    static let missed1 = "\(String.missed)-1"
    static let missed2 = "\(String.missed)-2"
}
