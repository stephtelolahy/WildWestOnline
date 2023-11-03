//
//  EliminateSpec.swift
//  
//
//  Created by Hugues Telolahy on 05/05/2023.
//

import Quick
import Nimble
import Game

final class EliminateSpec: QuickSpec {
    override func spec() {
        describe("eliminating a player") {
            it("should remove from PlayOrder and emit event") {
                // Given
                let state = GameState.makeBuilder()
                    .withPlayer("p1")
                    .withPlayer("p2")
                    .build()

                // When
                let action = GameAction.eliminate(player: "p1")
                let result = GameState.reducer(state, action)

                // Then
                expect(result.event) == action
                expect(result.playOrder) == ["p2"]
            }

            it("should remove queued effects") {
                // Given
                let state = GameState.makeBuilder()
                    .withPlayer("p1")
                    .withQueue([.effect(.draw, ctx: EffectContext(actor: "p1", card: "c1", triggeringAction: .group([])))])
                    .build()

                // When
                let action = GameAction.eliminate(player: "p1")
                let result = GameState.reducer(state, action)

                // Then
                expect(result.event) == action
                expect(result.queue).to(beEmpty())
            }
        }
    }
}
