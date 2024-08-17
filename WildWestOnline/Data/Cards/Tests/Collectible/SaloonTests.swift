//
//  SaloonTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class SaloonTests: XCTestCase {
    func test_playSaloon_withSomePlayersDamaged_shouldHealOneLifePoint() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.saloon])
                    .withHealth(4)
                    .withAttributes([.maxHealth: 4])
            }
            .withPlayer("p2") {
                $0.withHealth(2)
                    .withAttributes([.maxHealth: 4])
            }
            .withPlayer("p3") {
                $0.withHealth(3)
                    .withAttributes([.maxHealth: 4])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.saloon, player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .preparePlay(.saloon, player: "p1"),
            .discardPlayed(.saloon, player: "p1"),
            .heal(1, player: "p2"),
            .heal(1, player: "p3")
        ])
    }

    func test_playSaloon_withoutPlayerDamaged_shouldThrowError() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.saloon])
                    .withHealth(4)
                    .withAttributes([.maxHealth: 4])
            }
            .withPlayer("p2") {
                $0.withHealth(3)
                    .withAttributes([.maxHealth: 3])
            }
            .build()

        // When
        // Then
        let action = GameAction.preparePlay(.saloon, player: "p1")
        XCTAssertThrowsError(try awaitAction(action, state: state)) { error in
            XCTAssertEqual(error as? ArgPlayer.Error, .noPlayer(.damaged))
        }
    }
}
