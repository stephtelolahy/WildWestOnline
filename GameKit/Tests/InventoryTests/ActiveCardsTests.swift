//
//  ActiveCardsTests.swift
//  
//
//  Created by Hugues Telolahy on 05/06/2023.
//

import XCTest
import Game
import Inventory

final class ActiveCardsTests: XCTestCase {
    func test_ActivatingCards_GameIdle_ShouldEmitCurrentTurnActiveCards() {
        // Given
        let state = createGameWithCardRef {
            Player("p1") {
                Hand {
                    String.beer
                    String.saloon
                    String.gatling
                }
            }
            .attribute(.maxHealth, 4)
            .ability(.evaluateActiveCardsOnIdle)
            .health(2)
            Player("p2")
                .attribute(.maxHealth, 4)
        }
        .turn("p1")

        // When
        let action = GameAction.group([])
        let result = awaitAction(action, state: state, continueOnQueueEmpty: true)

        // Then
        XCTAssertEqual(result, [
            .activateCards(player: "p1", cards: [.saloon, .gatling])
        ])
    }
}
