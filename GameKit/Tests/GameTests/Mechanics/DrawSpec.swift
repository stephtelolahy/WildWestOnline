//
//  DrawSpec.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

import Game
import Nimble
import Quick

final class DrawSpec: QuickSpec {
    override func spec() {
        describe("draw") {
            context("deck containing cards") {
                it("should remove top card") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1")
                        .withDeck(["c1", "c2"])
                        .build()

                    // When
                    let action = GameAction.drawDeck(player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.player("p1").hand.cards) == ["c1"]
                    expect(result.deck.top) == "c2"
                }
            }

            context("deck empty") {
                context("enough discard pile") {
                    it("should reset deck") {
                        // Given
                        let state = GameState.makeBuilder()
                            .withPlayer("p1")
                            .withDiscard(["c1", "c2"])
                            .build()

                        // When
                        let action = GameAction.drawDeck(player: "p1")
                        let result = GameState.reducer(state, action)

                        // Then
                        expect(result.deck.top) == nil
                        expect(result.discard.top) == "c1"
                        expect(result.player("p1").hand.cards) == ["c2"]
                    }
                }

                context("not enough discard pile") {
                    it("should throw error") {
                        // Given
                        let state = GameState.makeBuilder()
                            .withPlayer("p1")
                            .build()

                        // When
                        let action = GameAction.drawDeck(player: "p1")
                        let result = GameState.reducer(state, action)

                        // Then
                        expect(result.error) == .deckIsEmpty
                    }
                }
            }
        }
    }
}
