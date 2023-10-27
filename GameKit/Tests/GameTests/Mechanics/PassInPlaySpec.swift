//
//  PassInPlaySpec.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 27/06/2023.
//

import Quick
import Nimble
import Game

final class PassInPlaySpec: QuickSpec {
    override func spec() {
        describe("pass in play") {
            it("should remove card from inPlay") {
                // Given
                let state = GameState.makeBuilder()
                    .withPlayer("p1") {
                        $0.withInPlay(["c1", "c2"])
                    }
                    .withPlayer("p2")
                    .build()

                // When
                let action = GameAction.passInplay("c1", target: "p2", player: "p1")
                let result = GameState.reducer(state, action)

                // Then
                expect(result.event) == action
                expect(result.player("p1").inPlay.cards) == ["c2"]
                expect(result.player("p2").inPlay.cards) == ["c1"]
            }

            context("missing card") {
                it("should throw error") {
                    let state = GameState.makeBuilder()
                        .withPlayer("p1")
                        .withPlayer("p2")
                        .build()

                    // When
                    let action = GameAction.passInplay("c1", target: "p2", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.error) == .cardNotFound("c1")
                }
            }
        }
    }
}
