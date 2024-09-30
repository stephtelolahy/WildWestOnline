//
//  RevCarabineTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct RevCarabineTests {
    @Test func playRevCarabine_shouldEquipAndSetWeapon() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.revCarabine])
                    .withAbilities([.updateAttributesOnChangeInPlay])
                    .withWeapon(1)
            }
            .build()

        // When
        let action = GameAction.preparePlay(.revCarabine, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .playEquipment(.revCarabine, player: "p1"),
            .setWeapon(4, player: "p1")
        ])
    }
}
