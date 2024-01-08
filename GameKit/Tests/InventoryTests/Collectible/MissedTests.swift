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
        let action = GameAction.play(.bang, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["p2", .missed])

        // Then
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
            .chooseOne(.counter, options: [.missed, .pass], player: "p2"),
            .choose(.missed, player: "p2"),
            .play(.missed, player: "p2"),
            .discardPlayed(.missed, player: "p2"),
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
        let action = GameAction.play(.bang, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["p2", .missed2])

        // Then
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .choose("p2", player: "p1"),
            .chooseOne(.counter, options: [.missed1, .missed2], player: "p2"),
            .choose(.missed2, player: "p2"),
            .play(.missed2, player: "p2"),
            .discardPlayed(.missed2, player: "p2"),
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
            .play(.gatling, player: "p1"),
            .discardPlayed(.gatling, player: "p1"),
            .chooseOne(.counter, options: [.missed, .pass], player: "p2"),
            .choose(.missed, player: "p2"),
            .play(.missed, player: "p2"),
            .discardPlayed(.missed, player: "p2"),
            .cancel(.damage(1, player: "p2")),
            .chooseOne(.counter, options: [.missed, .pass], player: "p3"),
            .choose(.missed, player: "p3"),
            .play(.missed, player: "p3"),
            .discardPlayed(.missed, player: "p3"),
            .cancel(.damage(1, player: "p3"))
        ])
    }
}

private extension String {
    static let missed1 = "\(String.missed)-1"
    static let missed2 = "\(String.missed)-2"
}
