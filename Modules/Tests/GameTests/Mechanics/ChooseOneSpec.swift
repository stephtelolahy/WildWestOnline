//
//  ChooseOneSpec.swift
//
//
//  Created by Hugues Telolahy on 11/04/2023.
//

import Game
import Quick
import Nimble
import Redux

final class ChooseOneSpec: QuickSpec {
    override func spec() {
        let sut = GameReducer()
        var state: GameState!
        
        describe("chooseOne") {
            beforeEach {
                state = GameState {
                    Player("p1") {
                        Hand {
                            "c1"
                            "c2"
                            "c3"
                        }
                    }
                }
                .waiting("p1", options: [
                    "c1": .discard("c1", player: "p1"),
                    "c2": .discard("c2", player: "p1")
                ])
            }

            context("when dispatching waited action") {
                it("should remove waiting state") {
                    // When
                    let action = GameAction.discard("c1", player: "p1")
                    let result = sut.reduce(state: state, action: action)

                    // Then
                    expect(result.chooseOne) == nil
                    expect(result.event) == action
                }
            }

            context("when dispatching non waited action") {
                it("should throw error") {
                    // When
                    let action = GameAction.discard("c3", player: "p1")
                    let result = sut.reduce(state: state, action: action)

                    // Then
                    expect(result.chooseOne) != nil
                    expect(result.event) == .error(.unwaitedAction)
                }
            }
        }
    }
}
