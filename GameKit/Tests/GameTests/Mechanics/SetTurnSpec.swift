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
        let sut = GameReducer()
        
        describe("setting turn") {
            it("should set attribute and reset counters") {
                // Given
                let state = GameState()
                    .turn("px")
                    .counters(["counter1": 1, "counter2": 2])
                
                // When
                let action = GameAction.setTurn("p1")
                let result = sut.reduce(state: state, action: action)

                // Then
                expect(result.event) == action
                expect(result.turn) == "p1"
                expect(result.playCounter).to(beEmpty())
            }
        }
    }
}
