//
//  VolcanicSpec.swift
//  
//
//  Created by Hugues Telolahy on 09/09/2023.
//

import Quick
import Nimble
import Game

final class VolcanicSpec: QuickSpec {
    override func spec() {
        describe("playing volcanic") {
            context("no weapon inPlay") {
                it("should set bangsPerTurn") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .volcanic
                            }
                        }
                        .setupAttribute(.weapon, 1)
                        .setupAttribute(.bangsPerTurn, 1)
                        .attribute(.weapon, 1)
                        .attribute(.bangsPerTurn, 1)
                    }

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
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .volcanic
                            }
                            InPlay {
                                .schofield
                            }
                        }
                        .setupAttribute(.weapon, 1)
                        .setupAttribute(.bangsPerTurn, 1)
                        .attribute(.weapon, 2)
                        .attribute(.bangsPerTurn, 1)
                        .ability(.discardPreviousWeaponOnPlayWeapon)
                    }

                    // When
                    let action = GameAction.play(.volcanic, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playEquipment(.volcanic, player: "p1"),
                        .setAttribute(.weapon, value: 1, player: "p1"),
                        .setAttribute(.bangsPerTurn, value: 0, player: "p1"),
                        .discardInPlay(.schofield, player: "p1")
                    ]
                }
            }
        }
    }
}
