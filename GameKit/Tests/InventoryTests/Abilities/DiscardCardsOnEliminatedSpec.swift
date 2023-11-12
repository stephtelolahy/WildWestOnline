//
//  DiscardCardsOnEliminatedSpec.swift
//
//
//  Created by Hugues Telolahy on 18/05/2023.
//

import Quick
import Nimble
import Game

final class DiscardCardsOnEliminatedSpec: QuickSpec {
    override func spec() {
        describe("being eliminated") {
            context("having cards") {
                it("should discard cards") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand(["c1"])
                                .withInPlay(["c2"])
                                .withAttributes([.discardCardsOnEliminated: 0])
                        }
                        .withPlayer("p2")
                        .withPlayer("p3")
                        .build()
                    
                    // When
                    let action = GameAction.eliminate(player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)
                    
                    // Then
                    expect(result) == [
                        .eliminate(player: "p1"),
                        .discardInPlay("c2", player: "p1"),
                        .discardHand("c1", player: "p1")
                    ]
                }
            }
        }
    }
}
