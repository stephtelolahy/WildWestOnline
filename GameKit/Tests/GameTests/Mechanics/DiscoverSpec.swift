//
//  DiscoverSpec.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

import Quick
import Nimble
import Game

final class DiscoverSpec: QuickSpec {
    override func spec() {
        let sut = GameReducer()

        describe("DrawToArena") {
            context("chosable nil") {
                it("should draw top deck and create arena") {
                    // Given
                    let state = GameState {
                        Deck {
                            "c1"
                            "c2"
                            "c3"
                        }
                    }

                    // When
                    let action = GameAction.discover
                    let result = sut.reduce(state: state, action: action)

                    // Then
                    expect(result.event) == action
                    expect(result.arena?.cards) == ["c1"]
                    expect(result.deck.top) == "c2"
                }
            }

            context("chosable containing card") {
                it("should draw top deck and add to arena") {
                    // Given
                    let state = GameState {
                        Deck {
                            "c2"
                            "c3"
                        }
                        Arena {
                            "c1"
                        }
                    }

                    // When
                    let action = GameAction.discover
                    let result = sut.reduce(state: state, action: action)

                    // Then
                    expect(result.event) == action
                    expect(result.arena?.cards) == ["c1", "c2"]
                    expect(result.deck.top) == "c3"
                }
            }
        }
    }
}
