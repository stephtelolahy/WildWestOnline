//
//  SchofieldSpec.swift
//
//
//  Created by Hugues Telolahy on 17/07/2023.
//

import Quick
import Nimble
import Game

final class SchofieldSpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("playing schofield") {
            context("no weapon inPlay") {
                it("should equip") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.schofield])
                                .withAttributes([.weapon: 1])
                                .withStartAttributes([.weapon: 1])
                                .withAbilities([.evaluateAttributesOnUpdateInPlay])
                        }
                        .build()

                    // When
                    let action = GameAction.play(.schofield, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playEquipment(.schofield, player: "p1"),
                        .setAttribute(.weapon, value: 2, player: "p1")
                    ]
                }
            }

            context("already playing another weapon") {
                it("should discard previous weapon") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.schofield])
                                .withInPlay([.remington])
                                .withAttributes([.weapon: 3])
                                .withStartAttributes([.weapon: 1])
                                .withAbilities([.discardPreviousWeaponOnPlayWeapon, .evaluateAttributesOnUpdateInPlay])
                        }
                        .build()

                    // When
                    let action = GameAction.play(.schofield, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playEquipment(.schofield, player: "p1"),
                        .discardInPlay(.remington, player: "p1"),
                        .setAttribute(.weapon, value: 2, player: "p1")
                    ]
                }
            }
        }

        describe("discarding schofield") {
            context("from inPlay") {
                it("should reset to default weapon") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withInPlay([.schofield])
                                .withAttributes([.weapon: 2])
                                .withStartAttributes([.weapon: 1])
                                .withAbilities([.evaluateAttributesOnUpdateInPlay])
                        }
                        .build()

                    // When
                    let action = GameAction.discardInPlay(.schofield, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .discardInPlay(.schofield, player: "p1"),
                        .setAttribute(.weapon, value: 1, player: "p1")
                    ]
                }
            }

            context("from hand") {
                it("should do nothing") {
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
                    expect(result) == [
                        .discardHand(.schofield, player: "p1")
                    ]
                }
            }
        }
    }
}
