//
//  PanicSpec.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//

import Quick
import Nimble
import Game

final class PanicSpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("playing Panic") {

            context("no player allowed") {
                it("should throw error") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .panic
                            }
                        }
                    }

                    // When
                    let action = GameAction.play(.panic, actor: "p1")
                    let result = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [.error(.noPlayer(.selectAt(1)))]
                }
            }
            
            context("target is other") {
                context("having hand cards") {
                    it("should choose one random hand card") {
                        // Given
                        let state = createGameWithCardRef {
                            Player("p1") {
                                Hand {
                                    .panic
                                }
                            }
                            Player("p2") {
                                Hand {
                                    "c21"
                                }
                            }
                        }
                        
                        // When
                        let action = GameAction.play(.panic, actor: "p1")
                        let result = self.awaitAction(action, choices: ["p2", .randomHand], state: state)
                        
                        // Then
                        expect(result) == [
                            .chooseOne(player: "p1", options: [
                                "p2": .playImmediate(.panic, target: "p2", actor: "p1")
                            ]),
                            .playImmediate(.panic, target: "p2", actor: "p1"),
                            .chooseOne(player: "p1", options: [
                                .randomHand: .steal("c21", target: "p2", player: "p1")
                            ]),
                            .steal("c21", target: "p2", player: "p1")
                        ]
                    }
                }
                
                context("having inPlay cards") {
                    it("should choose one inPlay card") {
                        // Given
                        let state = createGameWithCardRef {
                            Player("p1") {
                                Hand {
                                    .panic
                                }
                            }
                            Player("p2") {
                                InPlay {
                                    "c21"
                                    "c22"
                                }
                            }
                        }
                        
                        // When
                        let action = GameAction.play(.panic, actor: "p1")
                        let result = self.awaitAction(action, choices: ["p2", "c22"], state: state)
                        
                        // Then
                        expect(result) == [
                            .chooseOne(player: "p1", options: [
                                "p2": .playImmediate(.panic, target: "p2", actor: "p1")
                            ]),
                            .playImmediate(.panic, target: "p2", actor: "p1"),
                            .chooseOne(player: "p1", options: [
                                "c21": .steal("c21", target: "p2", player: "p1"),
                                "c22": .steal("c22", target: "p2", player: "p1")
                            ]),
                            .steal("c22", target: "p2", player: "p1")
                        ]
                    }
                }
                
                context("having hand and inPlay cards") {
                    it("should choose one inPlay or random hand card") {
                        // Given
                        let state = createGameWithCardRef {
                            Player("p1") {
                                Hand {
                                    .panic
                                }
                            }
                            Player("p2") {
                                Hand {
                                    "c21"
                                }
                                InPlay {
                                    "c22"
                                    "c23"
                                }
                            }
                        }
                        
                        // When
                        let action = GameAction.play(.panic, actor: "p1")
                        let result = self.awaitAction(action, choices: ["p2", "c23"], state: state)
                        
                        // Then
                        expect(result) == [
                            .chooseOne(player: "p1", options: [
                                "p2": .playImmediate(.panic, target: "p2", actor: "p1")
                            ]),
                            .playImmediate(.panic, target: "p2", actor: "p1"),
                            .chooseOne(player: "p1", options: [
                                .randomHand: .steal("c21", target: "p2", player: "p1"),
                                "c22": .steal("c22", target: "p2", player: "p1"),
                                "c23": .steal("c23", target: "p2", player: "p1")
                            ]),
                            .steal("c23", target: "p2", player: "p1")
                        ]
                    }
                }
            }
            
            xcontext("target is self") {
                it("should choose one inPlay card") {
                    // Given
                    // When
                    // Then
                }
                
                it("should not choose hand cards") {
                    // Given
                    // When
                    // Then
                }
            }
        }
    }
}
