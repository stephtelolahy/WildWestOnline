//
//  PassInPlaySpec.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 27/06/2023.
//

import Game
import Nimble
import Quick

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
                let action = GameAction.passInPlay("c1", target: "p2", player: "p1")
                let result = GameState.reducer(state, action)

                // Then
                expect(result.player("p1").inPlay) == ["c2"]
                expect(result.player("p2").inPlay) == ["c1"]
            }
        }
    }
}
