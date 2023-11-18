//
//  StealSpec.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

import Quick
import Nimble
import Game

final class StealSpec: QuickSpec {
    override func spec() {
        describe("steal") {
            context("hand card") {
                it("should remove card from hand") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1")
                        .withPlayer("p2") {
                            $0.withHand(["c21", "c22"])
                        }
                        .build()

                    // When
                    let action = GameAction.stealHand("c21", target: "p2", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.player("p1").hand.cards) == ["c21"]
                    expect(result.player("p2").hand.cards) == ["c22"]
                }
            }

            context("inPlay card") {
                it("should remove card from inPlay") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1")
                        .withPlayer("p2") {
                            $0.withInPlay(["c21", "c22"])
                        }
                        .build()

                    // When
                    let action = GameAction.stealInPlay("c21", target: "p2", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.player("p1").hand.cards) == ["c21"]
                    expect(result.player("p2").inPlay.cards) == ["c22"]
                }
            }

            context("missing card") {
                it("should throw error") {
                    let state = GameState.makeBuilder()
                        .withPlayer("p1")
                        .withPlayer("p2")
                        .build()

                    // When
                    let action = GameAction.stealHand("c2", target: "p1", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.error) == .cardNotFound("c2")
                }
            }
        }
    }
}
