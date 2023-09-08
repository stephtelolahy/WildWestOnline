//
//  VolcanicSpec.swift
//  
//
//  Created by Hugues Telolahy on 08/09/2023.
//

import Quick
import Nimble
import Game

final class VolcanicSpec: QuickSpec {
    override func spec() {
        describe("playing volcanic") {
            xcontext("no weapon") {
                it("should equip") {
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
                    let action = GameAction.play(.winchester, player: "p1")
                    let result = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playEquipment(.volcanic, player: "p1"),
                        .setAttribute(.bangsPerTurn, value: 0, player: "p1")
                    ]
                }
            }

            xcontext("already playing another weapon") {
                it("should equip") {
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
                    }

                    // When
                    let action = GameAction.play(.volcanic, player: "p1")
                    let result = self.awaitAction(action, state: state)

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
