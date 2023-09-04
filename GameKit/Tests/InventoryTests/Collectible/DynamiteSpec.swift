//
//  DynamiteSpec.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 26/06/2023.
//

import Quick
import Nimble
import Game

final class DynamiteSpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("playing dynamite") {
            it("should equip") {
                // Given
                let state = createGameWithCardRef {
                    Player("p1") {
                        Hand {
                            .dynamite
                        }
                    }
                }
                
                // When
                let action = GameAction.play(.dynamite, player: "p1")
                let result = self.awaitAction(action, state: state)
                
                // Then
                expect(result) == [
                    .playEquipment(.dynamite, player: "p1")
                ]
            }
        }
        
        describe("triggering dynamite") {
            context("flipped card is hearts") {
                it("should pass inPlay") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            InPlay {
                                .dynamite
                            }
                        }
                        .attribute(.flippedCards, 1)
                        .ability(.drawOnSetTurn)
                        .attribute(.startTurnCards, 2)
                        Player("p2")
                        Deck {
                            "c1-9♦️"
                            "c2"
                            "c3"
                        }
                    }
                    
                    // When
                    let action = GameAction.setTurn("p1")
                    let result = self.awaitAction(action, state: state)
                    
                    // Then
                    expect(result) == [.setTurn("p1"),
                                       .luck,
                                       .passInplay(.dynamite, target: "p2", player: "p1"),
                                       .draw(player: "p1"),
                                       .draw(player: "p1")]
                }
            }
            
            context("flipped card is spades") {
                context("not lethal") {
                    it("should apply damage and discard card") {
                        // Given
                        let state = createGameWithCardRef {
                            Player("p1") {
                                InPlay {
                                    .dynamite
                                }
                            }
                            .attribute(.flippedCards, 1)
                            .attribute(.startTurnCards, 2)
                            .ability(.drawOnSetTurn)
                            .health(4)
                            Deck {
                                "c1-8♠️"
                                "c2"
                                "c2"
                            }
                        }
                        
                        // When
                        let action = GameAction.setTurn("p1")
                        let result = self.awaitAction(action, state: state)
                        
                        // Then
                        expect(result) == [.setTurn("p1"),
                                           .luck,
                                           .damage(3, player: "p1"),
                                           .discardInPlay("dynamite", player: "p1"),
                                           .draw(player: "p1"),
                                           .draw(player: "p1")]
                    }
                }
                
                context("lethal") {
                    it("should eliminate") {
                        // Given
                        let state = createGameWithCardRef {
                            Player("p1") {
                                InPlay {
                                    .dynamite
                                }
                            }
                            .attribute(.flippedCards, 1)
                            .ability(.eliminateOnLooseLastHealth)
                            .ability(.discardCardsOnEliminated)
                            .ability(.nextTurnOnEliminated)
                            .health(3)
                            Player("p2")
                                .ability(.drawOnSetTurn)
                                .attribute(.startTurnCards, 2)
                            Player("p3")
                            Deck {
                                "c1-8♠️"
                                "c2"
                                "c2"
                            }
                        }
                        
                        // When
                        let action = GameAction.setTurn("p1")
                        let result = self.awaitAction(action, state: state)
                        
                        // Then
                        expect(result) == [.setTurn("p1"),
                                           .luck,
                                           .damage(3, player: "p1"),
                                           .eliminate(player: "p1"),
                                           .discardInPlay("dynamite", player: "p1"),
                                           .setTurn("p2"),
                                           .draw(player: "p2"),
                                           .draw(player: "p2")]
                    }
                }
            }
        }
    }
}
