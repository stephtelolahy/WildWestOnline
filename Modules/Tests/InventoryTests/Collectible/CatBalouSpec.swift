//
//  CatBalouSpec.swift
//
//
//  Created by Hugues Telolahy on 10/04/2023.
//

import Quick
import Nimble
import Game

final class CatBalouSpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("playing catBalou") {
            context("no player allowed") {
                it("should throw error") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .catBalou
                            }
                        }
                    }

                    // When
                    let action = GameAction.play(.catBalou, actor: "p1")
                    let result = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [.error(.noPlayer(.selectAny))]
                }
            }
            
            context("target is other") {
                context("having hand cards") {
                    it("should choose one random hand card") {
                        // Given
                        let state = createGameWithCardRef {
                            Player("p1") {
                                Hand {
                                    .catBalou
                                }
                            }
                            Player("p2") {
                                Hand {
                                    "c21"
                                }
                            }
                        }
                        
                        // When
                        let action = GameAction.play(.catBalou, actor: "p1")
                        let result = self.awaitAction(action, choices: ["p2", .randomHand], state: state)
                        
                        // Then
                        expect(result) == [
                            .chooseOne(player: "p1", options: [
                                "p2": .playImmediate(.catBalou, target: "p2", actor: "p1")
                            ]),
                            .playImmediate(.catBalou, target: "p2", actor: "p1"),
                            .chooseOne(player: "p1", options: [
                                .randomHand: .discard("c21", player: "p2")
                            ]),
                            .discard("c21", player: "p2")
                        ]
                    }
                }
                
                context("having inPlay cards") {
                    it("should choose one inPlay card") {
                        // Given
                        let state = createGameWithCardRef {
                            Player("p1") {
                                Hand {
                                    .catBalou
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
                        let action = GameAction.play(.catBalou, actor: "p1")
                        let result = self.awaitAction(action, choices: ["p2", "c22"], state: state)
                        
                        // Then
                        expect(result) == [
                            .chooseOne(player: "p1", options: [
                                "p2": .playImmediate(.catBalou, target: "p2", actor: "p1")
                            ]),
                            .playImmediate(.catBalou, target: "p2", actor: "p1"),
                            .chooseOne(player: "p1", options: [
                                "c21": .discard("c21", player: "p2"),
                                "c22": .discard("c22", player: "p2")
                            ]),
                            .discard("c22", player: "p2")
                        ]
                    }
                }
                
                context("having hand and inPlay cards") {
                    it("should choose one inPlay or random hand card") {
                        // Given
                        let state = createGameWithCardRef {
                            Player("p1") {
                                Hand {
                                    .catBalou
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
                        let action = GameAction.play(.catBalou, actor: "p1")
                        let result = self.awaitAction(action, choices: ["p2", "c23"], state: state)
                        
                        // Then
                        expect(result) == [
                            .chooseOne(player: "p1", options: [
                                "p2": .playImmediate(.catBalou, target: "p2", actor: "p1")
                            ]),
                            .playImmediate(.catBalou, target: "p2", actor: "p1"),
                            .chooseOne(player: "p1", options: [
                                .randomHand: .discard("c21", player: "p2"),
                                "c22": .discard("c22", player: "p2"),
                                "c23": .discard("c23", player: "p2")
                            ]),
                            .discard("c23", player: "p2")
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
