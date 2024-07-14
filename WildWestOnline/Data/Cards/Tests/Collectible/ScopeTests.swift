//
//  ScopeTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class ScopeTests: XCTestCase {
    func test_playScope_shouldEquipAndSetAttribute() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.scope])
                    .withAbilities([.updateAttributesOnChangeInPlay])
            }
            .build()

        // When
        let action = GameAction.play(.scope, player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .play(.scope, player: "p1"),
            .equip(.scope, player: "p1"),
            .setAttribute(.magnifying, value: 1, player: "p1")
        ])
    }

    func test_discardScope_shouldRemoveAttribute() throws {
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
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .discardInPlay(.scope, player: "p1"),
            .removeAttribute(.magnifying, player: "p1")
        ])
    }
}
