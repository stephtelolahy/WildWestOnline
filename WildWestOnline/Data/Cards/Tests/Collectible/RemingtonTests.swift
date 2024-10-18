//
//  RemingtonTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct RemingtonTests {
    @Test func playRemington_shouldEquipAndSetWeapon() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.remington])
                    .withAbilities([.updateAttributesOnChangeInPlay])
                    .withWeapon(1)
            }
            .build()

        // When
        let action = GameAction.preparePlay(.remington, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .playEquipment(.remington, player: "p1"),
            .setWeapon(3, player: "p1")
        ])
    }
}
