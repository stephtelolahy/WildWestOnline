//
//  VolcanicTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//
import GameCore
import XCTest

final class VolcanicTests: XCTestCase {
    func test_playVolcanic_withoutWeaponInPlay_shouldSetBangsPerTurn() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.volcanic])
                    .withAbilities([.updateAttributesOnChangeInPlay])
                    .withAttributes([.weapon: 1, .bangsPerTurn: 1])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.volcanic, player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .preparePlay(.volcanic, player: "p1"),
            .equip(.volcanic, player: "p1"),
            .setAttribute(.bangsPerTurn, value: 0, player: "p1")
        ])
    }
}
