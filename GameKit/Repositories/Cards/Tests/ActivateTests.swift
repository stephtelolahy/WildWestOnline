//
//  ActivateTests.swift
//
//
//  Created by Hugues Telolahy on 05/06/2023.
//

import GameCore
import XCTest

final class ActivateTests: XCTestCase {
    func test_activatingCards_withPlayableCards_shouldActivate() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.saloon, .gatling])
                    .withAttributes([.maxHealth: 4])
                    .withHealth(2)
            }
            .withPlayer("p2") {
                $0.withAttributes([.maxHealth: 4])
            }
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.nothing
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .activate([.saloon, .gatling], player: "p1")
        ])
    }

    func test_activatingCards_withoutPlayableCards_shouldDoNothing() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.beer, .missed])
                    .withAttributes([.maxHealth: 4])
                    .withHealth(4)
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.nothing
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [])
    }

    func test_activatingCards_withDeepPath_shouldCompleteWithReasonableDelay() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.saloon, .gatling, .missed, .duel, .barrel, .beer, .dynamite, .jail])
                    .withAttributes([.maxHealth: 4])
                    .withAbilities([.endTurn])
                    .withHealth(1)
            }
            .withPlayer("p2") {
                $0.withAttributes([.maxHealth: 4])
            }
            .withTurn("p1")
            .build()

        // When
        let action = GameAction.nothing
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result.count, 1)
    }
}
