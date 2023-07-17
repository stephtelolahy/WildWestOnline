//
//  GatlingSpec.swift
//  
//
//  Created by Hugues Telolahy on 22/04/2023.
//

import Quick
import Nimble
import Game

final class GatlingSpec: QuickSpec {
    override func spec() {
        describe("playing gatling") {
            context("three players") {
                it("should allow each player to counter or pass") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .gatling
                            }
                        }
                        Player("p2") {
                            Hand {
                                .missed
                            }
                        }
                        
                        Player("p3")
                    }
                    
                    // When
                    let action = GameAction.play(.gatling, actor: "p1")
                    let result = self.awaitAction(action, choices: [.missed, .pass], state: state)
                    
                    // Then
                    expect(result) == [
                        .playImmediate(.gatling, actor: "p1"),
                        .chooseOne(player: "p2", options: [
                            .missed: .discard(.missed, player: "p2"),
                            .pass: .damage(1, player: "p2")
                        ]),
                        .discard(.missed, player: "p2"),
                        .chooseOne(player: "p3", options: [
                            .pass: .damage(1, player: "p3")
                        ]),
                        .damage(1, player: "p3")
                    ]
                }
            }
            
            context("two players") {
                it("should allow each player to counter") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .gatling
                            }
                        }
                        Player("p2") {
                            Hand {
                                .missed
                            }
                        }
                    }
                    
                    // When
                    let action = GameAction.play(.gatling, actor: "p1")
                    let result = self.awaitAction(action, choices: [.missed], state: state)
                    
                    // Then
                    expect(result) == [
                        .playImmediate(.gatling, actor: "p1"),
                        .chooseOne(player: "p2", options: [
                            .missed: .discard(.missed, player: "p2"),
                            .pass: .damage(1, player: "p2")
                        ]),
                        .discard(.missed, player: "p2")
                    ]
                }
            }
        }
    }
}
