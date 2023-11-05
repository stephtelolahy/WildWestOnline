//
//  PlayImmediateSpec.swift
//
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Game
import Quick
import Nimble

final class PlayImmediateSpec: QuickSpec {
    override func spec() {
        let card1 = Card("c1") {
            CardEffect.nothing
                .on([.playImmediate])
        }

        describe("playing immediate card") {
            it("""
               should discard immediately
               AND emit event
               AND increment counter
               """) {
                // Given
                let state = GameState.makeBuilder()
                    .withPlayer("p1") {
                        $0.withHand(["c1"])
                    }
                    .withCardRef(["c1": card1])
                    .build()

                // When
                let action = GameAction.playImmediate("c1", player: "p1")
                let result = GameState.reducer(state, action)

                // Then
                expect(result.player("p1").hand.cards).to(beEmpty())
                expect(result.discard.top) == "c1"
                expect(result.event) == .playImmediate("c1", player: "p1")
                expect(result.playedThisTurn["c1"]) == 1
            }
        }
    }
}
