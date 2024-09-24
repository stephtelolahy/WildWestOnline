//
//  ScopeTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct ScopeTests {
    @Test func playScope_shouldEquipAndSetAttribute() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.scope])
                    .withAbilities([.updateAttributesOnChangeInPlay])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.scope, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .playEquipment(.scope, player: "p1"),
            .setAttribute(.magnifying, value: 1, player: "p1")
        ])
    }

    @Test func discardScope_shouldRemoveAttribute() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withInPlay([.scope])
                    .withAbilities([.updateAttributesOnChangeInPlay])
                    .withAttributes([.magnifying: 1])
            }
            .build()

        // When
        let action = GameAction.discardInPlay(.scope, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .discardInPlay(.scope, player: "p1"),
            .setAttribute(.magnifying, value: nil, player: "p1")
        ])
    }
}
