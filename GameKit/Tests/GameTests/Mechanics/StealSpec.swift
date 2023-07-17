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
        let sut = GameReducer()

        describe("steal") {
            context("hand card") {
                it("should remove card from hand") {
                    // Given
                    let state = GameState {
                        Player("p1")
                        Player("p2") {
                            Hand {
                                "c21"
                                "c22"
                            }
                        }
                    }

                    // When
                    let action = GameAction.steal("c21", target: "p2", player: "p1")
                    let result = sut.reduce(state: state, action: action)

                    // Then
                    expect(result.event) == action
                    expect(result.player("p1").hand.cards) == ["c21"]
                    expect(result.player("p2").hand.cards) == ["c22"]
                }
            }

            context("inPlay card") {
                it("should remove card from inPlay") {
                    // Given
                    let state = GameState {
                        Player("p1")
                        Player("p2") {
                            InPlay {
                                "c21"
                                "c22"
                            }
                        }
                    }

                    // When
                    let action = GameAction.steal("c21", target: "p2", player: "p1")
                    let result = sut.reduce(state: state, action: action)

                    // Then
                    expect(result.event) == action
                    expect(result.player("p1").hand.cards) == ["c21"]
                    expect(result.player("p2").inPlay.cards) == ["c22"]
                }
            }

            context("missing card") {
                it("should throw error") {
                    let state = GameState {
                        Player("p1")
                        Player("p2")
                    }

                    // When
                    let action = GameAction.steal("c2", target: "p1", player: "p1")
                    let result = sut.reduce(state: state, action: action)

                    // Then
                    expect(result.event) == .error(.cardNotFound("c2"))
                }
            }
        }
    }
}
