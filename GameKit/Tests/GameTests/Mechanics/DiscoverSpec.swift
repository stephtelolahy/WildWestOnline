//
//  DiscoverSpec.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

import Game
import Nimble
import Quick

final class DiscoverSpec: QuickSpec {
    override func spec() {
        describe("DrawToArena") {
            context("chosable nil") {
                it("should draw top deck and create arena") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withDeck(["c1", "c2", "c3"])
                        .build()

                    // When
                    let action = GameAction.discover
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.arena?.cards) == ["c1"]
                    expect(result.deck.top) == "c2"
                }
            }

            context("chosable containing card") {
                it("should draw top deck and add to arena") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withDeck(["c2", "c3"])
                        .withArena(["c1"])
                        .build()

                    // When
                    let action = GameAction.discover
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.arena?.cards) == ["c1", "c2"]
                    expect(result.deck.top) == "c3"
                }
            }
        }
    }
}
