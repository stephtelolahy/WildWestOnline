//
//  LuckSpec.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

import Quick
import Nimble
import Game

final class LuckSpec: QuickSpec {
    override func spec() {
        describe("DrawToDiscard") {
            it("should draw top deck and put to discard") {
                // Given
                let state = GameState {
                    Deck {
                        "c2"
                        "c3"
                    }
                    DiscardPile {
                        "c1"
                    }
                }
                
                // When
                let action = GameAction.luck
                let result = GameState.reducer(state, action)
                
                // Then
                expect(result.event) == action
                expect(result.discard.top) == "c2"
                expect(result.deck.top) == "c3"
            }
        }
    }
}
