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
        let sut = GameReducer()
        var state: GameState!

        describe("heal") {
            context("being damaged") {

                beforeEach {
                    // Given
                    state = GameState {
                        Player("p1")
                            .attribute(.health, 2)
                            .attribute(.maxHealth, 4)
                    }
                }

                context("value less than damage") {
                    it("should gain life points") {
                        // When
                        let action = GameAction.heal(1, player: "p1")
                        let result = sut.reduce(state: state, action: action)

                        // Then
                        expect(result.event) == action
                        expect(result.player("p1").attributes[.health]) == 3
                    }
                }

                context("value equal to damage") {
                    it("should gain life points") {
                        // When
                        let action = GameAction.heal(2, player: "p1")
                        let result = sut.reduce(state: state, action: action)

                        // Then
                        expect(result.event) == action
                        expect(result.player("p1").attributes[.health]) == 4
                    }
                }

                context("value more than damage") {
                    it("should gain life points limited to max health") {
                        // When
                        let action = GameAction.heal(3, player: "p1")
                        let result = sut.reduce(state: state, action: action)

                        // Then
                        expect(result.event) == action
                        expect(result.player("p1").attributes[.health]) == 4
                    }
                }
            }

            context("already max health") {
                it("should throw error") {
                    // Given
                    let state = GameState {
                        Player("p1")
                            .attribute(.health, 4)
                            .attribute(.maxHealth, 3)
                    }

                    // When
                    let action = GameAction.heal(1, player: "p1")
                    let result = sut.reduce(state: state, action: action)

                    // Then
                    expect(result.event) == .error(.playerAlreadyMaxHealth("p1"))
                }
            }
        }
    }
}
