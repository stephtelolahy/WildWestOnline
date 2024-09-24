//
//  BeerTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct BeerTests {
    @Test func playingBeer_beingDamaged_shouldHealOneLifePoint() async throws {
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
        let result = try await dispatch(action, state: state)
        
        // Then
        #expect(result == [
            .playBrown(.beer, player: "p1"),
            .heal(1, player: "p1")
        ])
    }
    
    @Test func playingBeer_alreadyMaxHealth_shouldThrowError() async throws {
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
        await #expect(throws: PlayersState.Error.playerAlreadyMaxHealth("p1")) {
            try await dispatch(action, state: state)
        }
    }
    
    @Test func playingBeer_twoPlayersLeft_shouldThrowError() async throws {
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
        await #expect(throws: PlayReq.Error.noReq(.isPlayersAtLeast(3))) {
            try await dispatch(action, state: state)
        }
    }
}
