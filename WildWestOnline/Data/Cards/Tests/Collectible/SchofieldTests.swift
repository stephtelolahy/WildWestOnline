//
//  SchofieldTests.swift
//
//
//  Created by Hugues Telolahy on 17/07/2023.
//

import GameCore
import Testing

struct SchofieldTests {
    @Test func playSchofield_withoutWeaponInPlay_shouldSetWeapon() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.schofield])
                    .withAbilities([.updateAttributesOnChangeInPlay])
                    .withWeapon(1)
            }
            .build()

        // When
        let action = GameAction.preparePlay(.schofield, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .playEquipment(.schofield, player: "p1"),
            .setWeapon(2, player: "p1")
        ])
    }

    @Test func playSchofield_withAnotherWeaponInPlay_shouldDiscardPreviousWeapon() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.schofield])
                    .withInPlay([.remington])
                    .withAbilities([.updateAttributesOnChangeInPlay, .discardPreviousWeaponOnPlayWeapon])
                    .withWeapon(3)
            }
            .build()

        // When
        let action = GameAction.preparePlay(.schofield, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .playEquipment(.schofield, player: "p1"),
            .discardInPlay(.remington, player: "p1"),
            .setWeapon(2, player: "p1")
        ])
    }

    @Test func discardingWeaponFromInPlay_shouldResetToDefaultWeapon() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withInPlay([.schofield])
                    .withAbilities([.updateAttributesOnChangeInPlay])
                    .withWeapon(2)
                    .withFigure("f1")
            }
            .withExtraCards(["f1": Card(name: "f1", passive: [.setWeapon(1)])])
            .build()

        // When
        let action = GameAction.discardInPlay(.schofield, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .discardInPlay(.schofield, player: "p1"),
            .setWeapon(1, player: "p1")
        ])
    }

    @Test func discardingWeaponFromHand_shouldResetToDefaultWeapon() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.schofield])
            }
            .build()

        // When
        let action = GameAction.discardHand(.schofield, player: "p1")
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result == [
            .discardHand(.schofield, player: "p1")
        ])
    }
}
