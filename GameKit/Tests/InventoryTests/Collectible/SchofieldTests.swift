//
//  SchofieldTests.swift
//
//
//  Created by Hugues Telolahy on 17/07/2023.
//
// swiftlint:disable no_magic_numbers

import Game
import XCTest

final class SchofieldTests: XCTestCase {
    func test_playSchofield_withoutWeaponInPlay_shouldSetWeapon() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.schofield])
                    .withAttributes([.updateAttributesOnChangeInPlay: 0, .weapon: 1])
                    .withFigure(.pDefault)
            }
            .build()

        // When
        let action = GameAction.play(.schofield, player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .playEquipment(.schofield, player: "p1"),
            .setAttribute(.weapon, value: 2, player: "p1")
        ])
    }

    func test_playSchofield_withAnotherWeaponInPlay_shouldDiscardPreviousWeapon() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.schofield])
                    .withInPlay([.remington])
                    .withAttributes([
                        .discardPreviousWeaponOnPlayWeapon: 0,
                        .updateAttributesOnChangeInPlay: 0,
                        .weapon: 3
                    ])
                    .withFigure(.pDefault)
            }
            .build()

        // When
        let action = GameAction.play(.schofield, player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .playEquipment(.schofield, player: "p1"),
            .discardInPlay(.remington, player: "p1"),
            .setAttribute(.weapon, value: 2, player: "p1")
        ])
    }

    func test_discardingWeaponFromInPlay_shouldResetToDefaultWeapon() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withInPlay([.schofield])
                    .withAttributes([.updateAttributesOnChangeInPlay: 0, .weapon: 2])
                    .withFigure(.pDefault)
            }
            .build()

        // When
        let action = GameAction.discardInPlay(.schofield, player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .discardInPlay(.schofield, player: "p1"),
            .setAttribute(.weapon, value: 1, player: "p1")
        ])
    }

    func test_discardingWeaponFromHand_shouldResetToDefaultWeapon() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.schofield])
            }
            .build()

        // When
        let action = GameAction.discardHand(.schofield, player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .discardHand(.schofield, player: "p1")
        ])
    }
}
