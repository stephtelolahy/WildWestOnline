//
//  BeerTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//
// swiftlint:disable no_magic_numbers

import GameCore
import XCTest

final class BeerTests: XCTestCase {
    func test_playingBeer_beingDamaged_shouldHealOneLifePoint() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.beer])
                    .withHealth(2)
                    .withAttributes([.maxHealth: 3])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameAction.play(.beer, player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .play(.beer, player: "p1"),
            .discardPlayed(.beer, player: "p1"),
            .heal(1, player: "p1")
        ])
    }

    func test_playingBeer_alreadyMaxHealth_shouldThrowError() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.beer])
                    .withHealth(3)
                    .withAttributes([.maxHealth: 3])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameAction.play(.beer, player: "p1")
        let (_, error) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(error, .playerAlreadyMaxHealth("p1"))
    }

    func test_playingBeer_twoPlayersLeft_shouldThrowError() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.beer])
                    .withHealth(2)
                    .withAttributes([.maxHealth: 3])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.play(.beer, player: "p1")
        let (_, error) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(error, .noReq(.isPlayersAtLeast(3)))
    }
}
