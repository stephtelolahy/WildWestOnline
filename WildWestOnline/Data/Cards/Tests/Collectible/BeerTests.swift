//
//  BeerTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class BeerTests: XCTestCase {
    func test_playingBeer_beingDamaged_shouldHealOneLifePoint() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.beer])
                    .withHealth(2)
                    .withAttributes([.maxHealth: 3])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameAction.preparePlay(.beer, player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .playBrown(.beer, player: "p1"),
            .heal(1, player: "p1")
        ])
    }

    func test_playingBeer_alreadyMaxHealth_shouldThrowError() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.beer])
                    .withHealth(3)
                    .withAttributes([.maxHealth: 3])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        // Then
        let action = GameAction.preparePlay(.beer, player: "p1")
        XCTAssertThrowsError(try awaitAction(action, state: state)) { error in
            XCTAssertEqual(error as? PlayersState.Error, .playerAlreadyMaxHealth("p1"))
        }
    }

    func test_playingBeer_twoPlayersLeft_shouldThrowError() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.beer])
                    .withHealth(2)
                    .withAttributes([.maxHealth: 3])
            }
            .withPlayer("p2")
            .build()

        // When
        // Then
        let action = GameAction.preparePlay(.beer, player: "p1")
        XCTAssertThrowsError(try awaitAction(action, state: state)) { error in
            XCTAssertEqual(error as? PlayReq.Error, .noReq(.isPlayersAtLeast(3)))
        }
    }
}
