//
//  BeerTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct BeerTests {
    @Test func play_beingDamaged_shouldHealOneLifePoint() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.beer])
                    .withHealth(2)
                    .withMaxHealth(3)
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
    
    @Test func play_alreadyMaxHealth_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.beer])
                    .withHealth(3)
                    .withMaxHealth(3)
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()
        
        // When
        // Then
        let action = GameAction.preparePlay(.beer, player: "p1")
        await #expect(throws: GameState.Error.playerAlreadyMaxHealth("p1")) {
            try await dispatch(action, state: state)
        }
    }
    
    @Test func play_twoPlayersLeft_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.beer])
                    .withHealth(2)
                    .withMaxHealth(3)
            }
            .withPlayer("p2")
            .build()
        
        // When
        // Then
        let action = GameAction.preparePlay(.beer, player: "p1")
        await #expect(throws: TriggeredAbility.Selector.StateCondition.Error.noReq(.playersAtLeast(3))) {
            try await dispatch(action, state: state)
        }
    }
}
