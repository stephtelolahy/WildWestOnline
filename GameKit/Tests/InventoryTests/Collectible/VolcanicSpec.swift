//
//  VolcanicSpec.swift
//  
//
//  Created by Hugues Telolahy on 09/09/2023.
//

import Game
import Nimble
import Quick

final class VolcanicSpec: QuickSpec {
    override func spec() {
        describe("playing volcanic") {
            context("no weapon inPlay") {
                it("should set bangsPerTurn") {
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
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playEquipment(.volcanic, player: "p1"),
                        .setAttribute(.bangsPerTurn, value: 0, player: "p1")
                    ]
                }
            }

            context("already playing a weapon") {
                it("should discard previous weapon") {
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
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playEquipment(.volcanic, player: "p1"),
                        .discardInPlay(.schofield, player: "p1"),
                        .setAttribute(.weapon, value: 1, player: "p1"),
                        .setAttribute(.bangsPerTurn, value: 0, player: "p1")
                    ]
                }
            }
        }
    }
}
