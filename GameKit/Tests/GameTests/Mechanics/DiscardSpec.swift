//
//  DiscardSpec.swift
//
//
//  Created by Hugues Telolahy on 10/04/2023.
//

import Game
import Nimble
import Quick

final class DiscardSpec: QuickSpec {
    override func spec() {
        describe("discard") {
            context("hand card") {
                it("should remove card from hand") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withHand(["c1", "c2"])
                        }
                        .build()

                    // When
                    let action = GameAction.discardHand("c1", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.player("p1").hand) == ["c2"]
                    expect(result.discard.top) == "c1"
                }
            }

            context("inPlay card") {
                it("should remove card from inPlay") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withInPlay(["c1", "c2"])
                        }
                        .build()

                    // When
                    let action = GameAction.discardInPlay("c1", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.player("p1").inPlay) == ["c2"]
                    expect(result.discard.top) == "c1"
                }
            }
        }
    }
}
