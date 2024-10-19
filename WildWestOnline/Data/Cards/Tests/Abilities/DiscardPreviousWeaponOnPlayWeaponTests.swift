//
//  DiscardPreviousWeaponOnPlayWeaponTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 11/05/2024.
//

import GameCore
import Testing

struct DiscardPreviousWeaponOnPlayWeaponTests {
    /*
    @Test func playVolcanic_withWeaponInPlay_shouldDiscardPreviousWeapon() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.volcanic])
                    .withInPlay([.schofield])
                    .withAbilities([
                        .discardPreviousWeaponOnPlayWeapon,
                        .updateAttributesOnChangeInPlay
                    ])
                    .withAttributes([
                        .weapon: 2,
                        .bangsPerTurn: 1
                    ])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.volcanic, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .playEquipment(.volcanic, player: "p1"),
            .discardInPlay(.schofield, player: "p1"),
            .setAttribute(.bangsPerTurn, value: 0, player: "p1"),
            setWeapon(1, player: "p1")
        ])
    }
     */
}
