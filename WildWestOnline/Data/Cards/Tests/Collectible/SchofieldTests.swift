//
//  SchofieldTests.swift
//
//
//  Created by Hugues Telolahy on 17/07/2023.
//

import GameCore
import XCTest

final class SchofieldTests: XCTestCase {
    func test_playSchofield_withoutWeaponInPlay_shouldSetWeapon() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.schofield])
                    .withAbilities([.updateAttributesOnChangeInPlay])
                    .withAttributes([.weapon: 1])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.schofield, player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .playEquipment(.schofield, player: "p1"),
            .setAttribute(.weapon, value: 2, player: "p1")
        ])
    }

    func test_playSchofield_withAnotherWeaponInPlay_shouldDiscardPreviousWeapon() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.schofield])
                    .withInPlay([.remington])
                    .withAbilities([.updateAttributesOnChangeInPlay, .discardPreviousWeaponOnPlayWeapon])
                    .withAttributes([.weapon: 3])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.schofield, player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .playEquipment(.schofield, player: "p1"),
            .discardInPlay(.remington, player: "p1"),
            .setAttribute(.weapon, value: 2, player: "p1")
        ])
    }

    func test_discardingWeaponFromInPlay_shouldResetToDefaultWeapon() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withInPlay([.schofield])
                    .withAbilities([.updateAttributesOnChangeInPlay])
                    .withAttributes([.weapon: 2])
                    .withFigure("f1")
            }
            .withExtraCards(["f1": Card(name: "f1", setPlayerAttribute: [.weapon: 1])])
            .build()

        // When
        let action = GameAction.discardInPlay(.schofield, player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .discardInPlay(.schofield, player: "p1"),
            .setAttribute(.weapon, value: 1, player: "p1")
        ])
    }

    func test_discardingWeaponFromHand_shouldResetToDefaultWeapon() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.schofield])
            }
            .build()

        // When
        let action = GameAction.discardHand(.schofield, player: "p1")
        let result = try awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .discardHand(.schofield, player: "p1")
        ])
    }
}
