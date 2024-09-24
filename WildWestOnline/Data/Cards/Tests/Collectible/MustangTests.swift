//
//  MustangTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct MustangTests {
    @Test func playMustang_shouldEquipAndSetAttribute() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.mustang])
                    .withAbilities([.updateAttributesOnChangeInPlay])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.mustang, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .playEquipment(.mustang, player: "p1"),
            .setAttribute(.remoteness, value: 1, player: "p1")
        ])
    }
}
