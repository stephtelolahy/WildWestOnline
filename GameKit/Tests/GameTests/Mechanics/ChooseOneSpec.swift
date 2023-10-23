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
        var state: GameState!
        
        describe("chooseOne") {
            beforeEach {
                state = GameState.makeBuilder()
                    .withPlayer("p1") {
                        $0.withHand("c1", "c2", "c3")
                    }
                    .withChooseOne("p1", options: [
                        "c1": .discardHand("c1", player: "p1"),
                        "c2": .discardHand("c2", player: "p1")
                    ])
                    .build()
            }

            context("when dispatching waited action") {
                it("should remove waiting state") {
                    // When
                    let action = GameAction.discardHand("c1", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.chooseOne) == nil
                    expect(result.event) == action
                }
            }

            context("when dispatching non waited action") {
                it("should throw error") {
                    // When
                    let action = GameAction.discardHand("c3", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.chooseOne) != nil
                    expect(result.error) == .unwaitedAction
                }
            }
        }
    }
}
