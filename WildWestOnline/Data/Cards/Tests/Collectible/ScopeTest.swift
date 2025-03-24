//
//  ScopeTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct ScopeTest {
    @Test func playScope_shouldEquipAndSetAttribute() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.scope])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.scope, actor: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .equip(.scope, player: "p1"),
            .increaseMagnifying(1, player: "p1")
        ])
    }

    @Test func discardScope_shouldResetAttribute() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.scope])
                    .withMagnifying(1)
            }
            .build()

        // When
        let action = GameAction.discardInPlay(.scope, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .discardInPlay(.scope, player: "p1"),
            .increaseMagnifying(-1, player: "p1")
        ])
    }
}
