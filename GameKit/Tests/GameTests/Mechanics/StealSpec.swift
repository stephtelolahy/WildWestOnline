//
//  StealSpec.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

import Game
import Nimble
import Quick

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
                    let action = GameAction.drawHand("c21", target: "p2", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.player("p1").hand) == ["c21"]
                    expect(result.player("p2").hand) == ["c22"]
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
                    let action = GameAction.drawInPlay("c21", target: "p2", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.player("p1").hand) == ["c21"]
                    expect(result.player("p2").inPlay) == ["c22"]
                }
            }
        }
    }
}
