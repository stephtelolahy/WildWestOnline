//
//  SchofieldTests.swift
//
//
//  Created by Hugues Telolahy on 17/07/2023.
//

import XCTest
import Game

final class SchofieldTests: XCTestCase {
    // swiftlint:disable:next function_body_length
    func test_playing_schofield_withNoWeaponInPlay_shouldEquip() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.schofield])
                    .withAttributes([.updateAttributesOnChangeInPlay: 0, .weapon: 1])
                    .withName(.pDefault)
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

    func test_playing_schofield_withAnotherWeaponInPlay_shouldDiscardPreviewWeapon() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.schofield])
                    .withInPlay([.remington])
                    .withAttributes([.discardPreviousWeaponOnPlayWeapon: 0, .updateAttributesOnChangeInPlay: 0, .weapon: 3])
                    .withName(.pDefault)
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

    func test_discardingFromInPlay_schofield_shouldResetToDefaultWeapon() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withInPlay([.schofield])
                    .withAttributes([.updateAttributesOnChangeInPlay: 0, .weapon: 2])
                    .withName(.pDefault)
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

    func test_discardingFromHand_schofield_shouldResetToDefaultWeapon() throws {
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
