//
//  GatlingTests.swift
//
//
//  Created by Hugues Telolahy on 22/04/2023.
//

import XCTest
import Game

final class GatlingTests: XCTestCase {
    
    func test_playGatling_withThreePlayers_shouldDamageEachPlayer() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.gatling])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()
        
        // When
        let action = GameAction.play(.gatling, player: "p1")
        let (result, _) = self.awaitAction(action, state: state)
        
        // Then
        XCTAssertEqual(result, [
            .playImmediate(.gatling, player: "p1"),
            .damage(1, player: "p2"),
            .damage(1, player: "p3")
        ])
    }
    
    func test_playGatling_withTwoPlayers_shouldDamageEachPlayer() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.gatling])
            }
            .withPlayer("p2")
            .build()
        
        // When
        let action = GameAction.play(.gatling, player: "p1")
        let (result, _) = self.awaitAction(action, state: state)
        
        // Then
        XCTAssertEqual(result, [
            .playImmediate(.gatling, player: "p1"),
            .damage(1, player: "p2")
        ])
    }
}