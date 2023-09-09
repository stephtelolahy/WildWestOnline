//
//  VolcanicTests.swift
//  
//
//  Created by Hugues Telolahy on 09/09/2023.
//

import XCTest
import Game

final class VolcanicTests: XCTestCase {
    
    func test_PlayingVolcanic_NoWeapon_ShouldSetBangsPerTurn() {
        // Given
        let state = createGameWithCardRef {
            Player("p1") {
                Hand {
                    .volcanic
                }
            }
            .setupAttribute(.weapon, 1)
            .setupAttribute(.bangsPerTurn, 1)
            .attribute(.weapon, 1)
            .attribute(.bangsPerTurn, 1)
        }
        
        // When
        let action = GameAction.play(.volcanic, player: "p1")
        let result = awaitAction(action, state: state)
        
        // Then
        XCTAssertEqual(result, [
            .playEquipment(.volcanic, player: "p1"),
            .setAttribute(.bangsPerTurn, value: 0, player: "p1")
        ])
    }
    
    func test_PlayingVolcanic_AlreadyPlayingWeapon_ShouldDiscardPreviousWeapon() {
        // Given
        let state = createGameWithCardRef {
            Player("p1") {
                Hand {
                    .volcanic
                }
                InPlay {
                    .schofield
                }
            }
            .setupAttribute(.weapon, 1)
            .setupAttribute(.bangsPerTurn, 1)
            .attribute(.weapon, 2)
            .attribute(.bangsPerTurn, 1)
            .ability(.discardPreviousWeaponOnPlayWeapon)
        }
        
        // When
        let action = GameAction.play(.volcanic, player: "p1")
        let result = awaitAction(action, state: state)
        
        // Then
        XCTAssertEqual(result, [
            .playEquipment(.volcanic, player: "p1"),
            .setAttribute(.weapon, value: 1, player: "p1"),
            .setAttribute(.bangsPerTurn, value: 0, player: "p1"),
            .discardInPlay(.schofield, player: "p1")
        ])
    }
}
