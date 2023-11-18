//
//  HealSpec.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

import Quick
import Nimble
import Game

final class HealSpec: QuickSpec {
    override func spec() {
        var state: GameState!

        describe("heal") {
            context("being damaged") {

                beforeEach {
                    // Given
                    state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withHealth(2)
                                .withAttributes([.maxHealth: 4])
                        }
                        .build()
                }

                context("amount less than damage") {
                    it("should gain life points") {
                        // When
                        let action = GameAction.heal(1, player: "p1")
                        let result = GameState.reducer(state, action)

                        // Then
                        expect(result.player("p1").health) == 3
                    }
                }

                context("amount equal to damage") {
                    it("should gain life points") {
                        // When
                        let action = GameAction.heal(2, player: "p1")
                        let result = GameState.reducer(state, action)

                        // Then
                        expect(result.player("p1").health) == 4
                    }
                }

                context("amount more than damage") {
                    it("should gain life points limited to max health") {
                        // When
                        let action = GameAction.heal(3, player: "p1")
                        let result = GameState.reducer(state, action)

                        // Then
                        expect(result.player("p1").health) == 4
                    }
                }
            }

            context("already max health") {
                it("should throw error") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withHealth(4)
                                .withAttributes([.maxHealth: 4])
                        }
                        .build()

                    // When
                    let action = GameAction.heal(1, player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.error) == .playerAlreadyMaxHealth("p1")
                }
            }
        }
    }
}
