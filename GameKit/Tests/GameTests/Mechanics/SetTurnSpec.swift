//
//  SetTurnSpec.swift
//  
//
//  Created by Hugues Telolahy on 01/05/2023.
//

import Quick
import Nimble
import Game

final class SetTurnSpec: QuickSpec {
    override func spec() {
        describe("setting turn") {
            it("should set attribute and reset counters") {
                // Given
                let state = GameState.makeBuilder()
                    .withPlayedThisTurn(["card1": 1, "card2": 2])
                    .build()

                // When
                let action = GameAction.setTurn("p1")
                let result = GameState.reducer(state, action)

                // Then
                expect(result.turn) == "p1"
                expect(result.playedThisTurn).to(beEmpty())
            }
        }
    }
}
