//
//  ChooseCardSpec.swift
//  
//
//  Created by Hugues Telolahy on 11/04/2023.
//

import Game
import Quick
import Nimble

final class ChooseCardSpec: QuickSpec {
    override func spec() {
        let sut = GameReducer()
        describe("choose a card") {
            context("specified") {
                context("multiple cards remaining") {
                    it("should draw that card") {
                        // Given
                        let state = GameState {
                            Player("p1")
                            Arena {
                                "c1"
                                "c2"
                            }
                        }

                        // When
                        let action = GameAction.chooseCard("c1", player: "p1")
                        let result = sut.reduce(state: state, action: action)

                        // Then
                        expect(result.event) == action
                        expect(result.player("p1").hand.cards) == ["c1"]
                        expect(result.arena?.cards) == ["c2"]
                    }
                }

                context("last card") {
                    it("should draw that card and delete card location") {
                        // Given
                        let state = GameState {
                            Player("p1")
                            Arena {
                                "c1"
                            }
                        }

                        // When
                        let action = GameAction.chooseCard("c1", player: "p1")
                        let result = sut.reduce(state: state, action: action)

                        // Then
                        expect(result.event) == action
                        expect(result.player("p1").hand.cards) == ["c1"]
                        expect(result.arena) == nil
                    }
                }
            }
        }
    }
}
