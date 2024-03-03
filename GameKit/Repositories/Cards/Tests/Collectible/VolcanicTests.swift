//
//  VolcanicTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//
import GameCore
import XCTest

final class VolcanicTests: XCTestCase {
    func test_playVolcanic_withoutWeaponInPlay_shouldSetBangsPerTurn() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.volcanic])
                    .withAbilities([.updateAttributesOnChangeInPlay])
                    .withAttributes([.weapon: 1, .bangsPerTurn: 1])
            }
            .build()

        // When
        let action = GameAction.play(.volcanic, player: "p1")
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .play(.volcanic, player: "p1"),
            .equip(.volcanic, player: "p1"),
            .setAttribute(.bangsPerTurn, value: 0, player: "p1")
        ])
    }

    func test_playVolcanic_withWeaponInPlay_shouldDiscardPreviousWeapon() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
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
        let action = GameAction.play(.volcanic, player: "p1")
        let (result, _) = awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .play(.volcanic, player: "p1"),
            .equip(.volcanic, player: "p1"),
            .discardInPlay(.schofield, player: "p1"),
            .setAttribute(.weapon, value: 1, player: "p1"),
            .setAttribute(.bangsPerTurn, value: 0, player: "p1")
        ])
    }
}
