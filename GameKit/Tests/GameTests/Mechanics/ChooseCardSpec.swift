//
//  ChooseCardSpec.swift
//  
//
//  Created by Hugues Telolahy on 11/04/2023.
//

import Game
import Nimble
import Quick

final class ChooseCardSpec: QuickSpec {
    override func spec() {
        describe("choose a card") {
            context("specified") {
                context("multiple cards remaining") {
                    it("should draw that card") {
                        // Given
                        let state = GameState.makeBuilder()
                            .withPlayer("p1")
                            .withArena(["c1", "c2"])
                            .build()

                        // When
                        let action = GameAction.chooseArena("c1", player: "p1")
                        let result = GameState.reducer(state, action)

                        // Then
                        expect(result.player("p1").hand.cards) == ["c1"]
                        expect(result.arena?.cards) == ["c2"]
                    }
                }

                context("last card") {
                    it("should draw that card and delete card location") {
                        // Given
                        let state = GameState.makeBuilder()
                            .withPlayer("p1")
                            .withArena(["c1"])
                            .build()

                        // When
                        let action = GameAction.chooseArena("c1", player: "p1")
                        let result = GameState.reducer(state, action)

                        // Then
                        expect(result.player("p1").hand.cards) == ["c1"]
                        expect(result.arena) == nil
                    }
                }
            }
        }
    }
}
