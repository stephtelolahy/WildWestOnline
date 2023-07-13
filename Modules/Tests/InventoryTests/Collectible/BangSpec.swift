//
//  BangSpec.swift
//  
//
//  Created by Hugues Telolahy on 16/04/2023.
//

import Game
import Quick
import Nimble

final class BangSpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("playing bang") {
            context("reached limit per turn") {
                it("should throw error") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .bang
                            }
                        }
                        Player("p2")
                    }
                        .counters([.bang: 1])
                    
                    // When
                    let action = GameAction.play(.bang, actor: "p1")
                    let result = self.awaitAction(action, state: state)
                    
                    // Assert
                    expect(result) == [.error(.noReq(.isTimesPerTurn(1)))]
                }
            }

            context("no player reachable") {
                it("should throw error") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .bang
                            }
                        }
                        Player("p2").attribute(.mustang, 1)
                        Player("p3")
                        Player("p4").attribute(.mustang, 1)
                    }

                    // When
                    let action = GameAction.play(.bang, actor: "p1")
                    let result = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [.error(.noPlayer(.selectReachable))]
                }
            }

            context("having missed") {
                it("should ask to counter or pass") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .bang
                            }
                        }
                        Player("p2") {
                            Hand {
                                .missed
                            }
                        }
                    }

                    // When
                    let action = GameAction.play(.bang, actor: "p1")
                    let result = self.awaitAction(action, choices: ["p2", .missed], state: state)

                    // Then
                    expect(result) == [
                        .chooseOne(player: "p1", options: [
                            "p2": .playImmediate(.bang, target: "p2", actor: "p1")
                        ]),
                        .playImmediate(.bang, target: "p2", actor: "p1"),
                        .chooseOne(player: "p2", options: [
                            .missed: .discard(.missed, player: "p2"),
                            .pass: .damage(1, player: "p2")
                        ]),
                        .discard(.missed, player: "p2")
                    ]
                }
            }

            context("not having missed") {
                it("should ask to pass only") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .bang
                            }
                        }
                        Player("p2")
                    }

                    // When
                    let action = GameAction.play(.bang, actor: "p1")
                    let result = self.awaitAction(action, choices: ["p2", .pass], state: state)

                    // Then
                    expect(result) == [
                        .chooseOne(player: "p1", options: [
                            "p2": .playImmediate(.bang, target: "p2", actor: "p1")
                        ]),
                        .playImmediate(.bang, target: "p2", actor: "p1"),
                        .chooseOne(player: "p2", options: [
                            .pass: .damage(1, player: "p2")
                        ]),
                        .damage(1, player: "p2")
                    ]
                }
            }
        }
    }
}
