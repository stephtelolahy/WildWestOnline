//
//  PlayHandicapSpec.swift
//  
//
//  Created by Hugues Telolahy on 11/06/2023.
//

import Game
import Nimble
import Quick

final class PlayHandicapSpec: QuickSpec {
    override func spec() {
        describe("playing handicap card") {
            context("not in play") {
                it("should put card in target's inplay") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withHand(["c1", "c2"])
                        }
                        .withPlayer("p2")
                        .build()

                    // When
                    let action = GameAction.playHandicap("c1", target: "p2", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.player("p1").hand) == ["c2"]
                    expect(result.player("p2").inPlay) == ["c1"]
                    expect(result.player("p1").inPlay).to(beEmpty())
                    expect(result.discard.count) == 0
                }
            }

            context("having same card in play") {
                it("should throw error") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withHand(["c-1"])
                        }
                        .withPlayer("p2") {
                            $0.withInPlay(["c-2"])
                        }
                        .build()

                    // When
                    let action = GameAction.playHandicap("c-1", target: "p2", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.error) == .cardAlreadyInPlay("c")
                }
            }
        }
    }
}
