//
//  PassInPlaySpec.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 27/06/2023.
//

import Quick
import Nimble
import Game

final class PassInPlaySpec: QuickSpec {
    override func spec() {
        let sut = GameReducer()

        describe("pass in play") {
            it("should remove card from inPlay") {
                // Given
                let state = GameState {
                    Player("p1") {
                        InPlay {
                            "c1"
                            "c2"
                        }
                    }
                    Player("p2")
                }

                // When
                let action = GameAction.passInplay("c1", target: "p2", player: "p1")
                let result = sut.reduce(state: state, action: action)

                // Then
                expect(result.event) == action
                expect(result.player("p1").inPlay.cards) == ["c2"]
                expect(result.player("p2").inPlay.cards) == ["c1"]
            }

            context("missing card") {
                it("should throw error") {
                    let state = GameState {
                        Player("p1")
                        Player("p2")
                    }

                    // When
                    let action = GameAction.passInplay("c1", target: "p2", player: "p1")
                    let result = sut.reduce(state: state, action: action)

                    // Then
                    expect(result.error) == .cardNotFound("c1")
                }
            }
        }
    }
}
