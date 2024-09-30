//
//  WinchesterTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct WinchesterTests {
    @Test func playWinchester_shouldEquipAndSetAttribute() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.winchester])
                    .withAbilities([.updateAttributesOnChangeInPlay])
                    .withWeapon(1)
            }
            .build()

        // When
        let action = GameAction.preparePlay(.winchester, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .playEquipment(.winchester, player: "p1"),
            .setWeapon(5, player: "p1"),
            .setWeapon(5, player: "p1")
        ])
    }
}
