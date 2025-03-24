//
//  MustangTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct MustangTests {
    @Test func playMustang_shouldEquipAndSetAttribute() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.mustang])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.mustang, actor: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .equip(.mustang, player: "p1"),
            .increaseRemoteness(1, player: "p1")
        ])
    }

    @Test func discardMistang_shouldResetAttribute() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.mustang])
                    .withRemoteness(1)
            }
            .build()

        // When
        let action = GameAction.discardInPlay(.mustang, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .discardInPlay(.mustang, player: "p1"),
            .increaseRemoteness(-1, player: "p1")
        ])
    }
}
