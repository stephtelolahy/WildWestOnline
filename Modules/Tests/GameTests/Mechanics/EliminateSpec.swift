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
        let sut = GameReducer()

        describe("eliminating a player") {
            it("should remove from PlayOrder and emit event") {
                // Given
                let state = GameState {
                    Player("p1")
                    Player("p2")
                }

                // When
                let action = GameAction.eliminate(player: "p1")
                let result = sut.reduce(state: state, action: action)

                // Then
                expect(result.event) == action
                expect(result.playOrder) == ["p2"]
            }

            it("should remove queued effects") {
                // Given
                let state = GameState {
                    Player("p1")
                    Player("p2")
                }
                .queue([
                    .resolve(.draw, ctx: [.actor: "p1"])
                ])

                // When
                let action = GameAction.eliminate(player: "p1")
                let result = sut.reduce(state: state, action: action)

                // Then
                expect(result.event) == action
                expect(result.queue).to(beEmpty())
            }
        }
    }
}
