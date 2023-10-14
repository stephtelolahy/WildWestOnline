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
                    let action = GameAction.play(.gatling, player: "p1")
                    let (result, _) = self.awaitAction(action, choices: [.missed], state: state)
                    
                    // Then
                    expect(result) == [
                        .playImmediate(.gatling, player: "p1"),
                        .chooseOne(player: "p2", options: [
                            .missed: .discardHand(.missed, player: "p2"),
                            .pass: .damage(1, player: "p2")
                        ]),
                        .discardHand(.missed, player: "p2"),
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
                    let action = GameAction.play(.gatling, player: "p1")
                    let (result, _) = self.awaitAction(action, choices: [.missed], state: state)
                    
                    // Then
                    expect(result) == [
                        .playImmediate(.gatling, player: "p1"),
                        .chooseOne(player: "p2", options: [
                            .missed: .discardHand(.missed, player: "p2"),
                            .pass: .damage(1, player: "p2")
                        ]),
                        .discardHand(.missed, player: "p2")
                    ]
                }
            }
        }
    }
}
