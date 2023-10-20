//
//  BarrelTests.swift
//
//
//  Created by Hugues Telolahy on 18/06/2023.
//

import Quick
import Nimble
import Game

final class BarrelSpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("playing barrel") {
            it("should equip") {
                // Given
                let state = createGameWithCardRef {
                    Player("p1") {
                        Hand {
                            .barrel
                        }
                    }
                }
                
                // When
                let action = GameAction.play(.barrel, player: "p1")
                let (result, _) = self.awaitAction(action, state: state)
                
                // Then
                expect(result) == [.playEquipment(.barrel, player: "p1")]
            }
        }
        
        describe("triggering barrel") {
            context("one flipped card") {
                context("flipped card is hearts") {
                    it("should cancel shot") {
                        // Given
                        let state = createGameWithCardRef {
                            Player("p1") {
                                Hand {
                                    .bang
                                }
                            }
                            .attribute(.weapon, 1)
                            Player("p2") {
                                InPlay {
                                    .barrel
                                }
                            }
                            .attribute(.flippedCards, 1)
                            Deck {
                                "c1-2♥️"
                            }
                        }
                        
                        // When
                        let action = GameAction.playImmediate(.bang, target: "p2", player: "p1")
                        let (result, _) = self.awaitAction(action, state: state)
                        
                        // Then
                        expect(result) == [
                            .playImmediate(.bang, target: "p2", player: "p1"),
                            .luck,
                            .cancel(.damage(1, player: "p2"))
                        ]
                    }
                }
                
                context("flipped card is spades") {
                    it("should apply damage") {
                        // Given
                        let state = createGameWithCardRef {
                            Player("p1") {
                                Hand {
                                    .bang
                                }
                            }
                            .attribute(.weapon, 1)
                            Player("p2") {
                                InPlay {
                                    .barrel
                                }
                            }
                            .attribute(.flippedCards, 1)
                            Deck {
                                "c1-A♠️"
                            }
                        }
                        
                        // When
                        let action = GameAction.playImmediate(.bang, target: "p2", player: "p1")
                        let (result, _) = self.awaitAction(action, state: state)

                        // Then
                        expect(result) == [
                            .playImmediate(.bang, target: "p2", player: "p1"),
                            .luck,
                            .damage(1, player: "p2")
                        ]
                    }
                }
            }
            
            context("two flipped cards") {
                context("one of flipped card is hearts") {
                    it("should cancel shot") {
                        // Given
                        let state = createGameWithCardRef {
                            Player("p1") {
                                Hand {
                                    .bang
                                }
                            }
                            .attribute(.weapon, 1)
                            Player("p2") {
                                InPlay {
                                    .barrel
                                }
                            }
                            .attribute(.flippedCards, 2)
                            Deck {
                                "c1-A♠️"
                                "c1-2♥️"
                            }
                        }

                        // When
                        let action = GameAction.playImmediate(.bang, target: "p2", player: "p1")
                        let (result, _) = self.awaitAction(action, state: state)

                        // Then
                        expect(result) == [
                            .playImmediate(.bang, target: "p2", player: "p1"),
                            .luck,
                            .luck,
                            .cancel(.damage(1, player: "p2"))
                        ]
                    }
                }
            }

            context("holding missed cards") {
                it("should not choose play missed") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .bang
                            }
                        }
                        .attribute(.bangsPerTurn, 1)
                        .attribute(.weapon, 1)
                        Player("p2") {
                            Hand {
                                .missed
                                "missed-2"
                            }
                            InPlay {
                                .barrel
                                "barrel-2"
                            }
                        }
                        .attribute(.flippedCards, 1)
                        Deck {
                            "c1-2♥️"
                        }
                    }

                    // When
                    let action = GameAction.playImmediate(.bang, target: "p2", player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playImmediate(.bang, target: "p2", player: "p1"),
                        .luck,
                        .cancel(.damage(1, player: "p2"))
                    ]

                }
            }
        }
    }
}
