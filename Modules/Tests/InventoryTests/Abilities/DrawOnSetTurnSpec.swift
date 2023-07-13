//
//  DrawOnSetTurnSpec.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 02/05/2023.
//

import Quick
import Nimble
import Game

final class DrawOnSetTurnSpec: QuickSpec {
    override func spec() {
        describe("starting turn") {
            context("a player with 2 initial cards") {
                it("should draw 2 cards") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1")
                        Player("p2")
                        Deck {
                            "c1"
                            "c2"
                        }
                    }
                    .ability(.drawOnSetTurn)
                    
                    // When
                    let action = GameAction.setTurn("p1")
                    let result = self.awaitAction(action, state: state)
                    
                    // Then
                    expect(result) == [
                        .setTurn("p1"),
                        .draw(player: "p1"),
                        .draw(player: "p1")
                    ]
                }
            }
            
            context("a player with 3 initial cards") {
                it("should draw 3 cards") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1")
                            .attribute(.starTurnCards, 3)
                        Player("p2")
                        Deck {
                            "c1"
                            "c2"
                            "c3"
                        }
                    }
                    .ability(.drawOnSetTurn)

                    // When
                    let action = GameAction.setTurn("p1")
                    let result = self.awaitAction(action, state: state)
                    
                    // Then
                    expect(result) == [
                        .setTurn("p1"),
                        .draw(player: "p1"),
                        .draw(player: "p1"),
                        .draw(player: "p1")
                    ]
                }
            }
        }
    }
}
