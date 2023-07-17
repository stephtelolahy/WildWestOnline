//
//  NextTurnOnEliminatedSpec.swift
//  
//
//  Created by Hugues Telolahy on 16/05/2023.
//

import Quick
import Nimble
import Game

final class NextTurnOnEliminatedSpec: QuickSpec {
    override func spec() {
        describe("being eliminated") {
            context("current turn") {
                it("should next turn") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1")
                        Player("p2")
                        Player("p3")
                    }
                    .ability(.nextTurnOnEliminated)
                    .turn("p3")

                    // When
                    let action = GameAction.eliminate(player: "p3")
                    let result = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .eliminate(player: "p3"),
                        .setTurn("p1")
                    ]
                }
            }
            
            context("current turn and having cards") {
                it("should successively discard cards, set next turn, next player draw cards") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                "c11"
                            }
                            InPlay {
                                "c12"
                            }
                        }
                        Player("p2")
                        Player("p3")
                        Deck {
                            "c1"
                            "c2"
                        }
                    }
                    .ability(.discardCardsOnEliminated)
                    .ability(.nextTurnOnEliminated)
                    .ability(.drawOnSetTurn)
                    .turn("p1")

                    // When
                    let action = GameAction.eliminate(player: "p1")
                    let result = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .eliminate(player: "p1"),
                        .discard("c12", player: "p1"),
                        .discard("c11", player: "p1"),
                        .setTurn("p2"),
                        .draw(player: "p2"),
                        .draw(player: "p2")
                    ]
                }
            }
        }
    }
}
