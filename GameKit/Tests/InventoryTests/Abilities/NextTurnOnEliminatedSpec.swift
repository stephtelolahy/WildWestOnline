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
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1")
                        .withPlayer("p2")
                        .withPlayer("p3") {
                            $0.withAbilities([.nextTurnOnEliminated])
                        }
                        .withTurn("p3")
                        .build()

                    // When
                    let action = GameAction.eliminate(player: "p3")
                    let (result, _) = self.awaitAction(action, state: state)

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
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand(["c11"])
                                .withInPlay(["c12"])
                                .withAbilities([.discardCardsOnEliminated, .nextTurnOnEliminated])
                        }
                        .withPlayer("p2") {
                            $0.withAbilities([.drawOnSetTurn])
                                .withAttributes([.startTurnCards: 2])
                        }
                        .withPlayer("p3")
                        .withDeck(["c1", "c2"])
                        .withTurn("p1")
                        .build()

                    // When
                    let action = GameAction.eliminate(player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .eliminate(player: "p1"),
                        .discardInPlay("c12", player: "p1"),
                        .discardHand("c11", player: "p1"),
                        .setTurn("p2"),
                        .draw(player: "p2"),
                        .draw(player: "p2")
                    ]
                }
            }
        }
    }
}
