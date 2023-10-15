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
            context("by default") {
                it("should damage by 1") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .bang
                            }
                        }
                        .attribute(.bangsPerTurn, 1)
                        .attribute(.weapon, 1)
                        Player("p2")
                    }

                    // When
                    let action = GameAction.play(.bang, player: "p1")
                    let (result, _) = self.awaitAction(action, choices: ["p2"], state: state)

                    // Then
                    expect(result) == [
                        .chooseOne(player: "p1", options: [
                            "p2": .playImmediate(.bang, target: "p2", player: "p1")
                        ]),
                        .playImmediate(.bang, target: "p2", player: "p1"),
                        .damage(1, player: "p2")
                    ]
                }
            }

            context("reached limit per turn") {
                it("should throw error") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .bang
                            }
                        }
                        .attribute(.weapon, 1)
                        .attribute(.bangsPerTurn, 1)
                        Player("p2")
                    }
                        .playCounters([.bang: 1])

                    // When
                    let action = GameAction.play(.bang, player: "p1")
                    let (_, error) = self.awaitAction(action, state: state)

                    // Assert
                    expect(error) == .noReq(.isCardPlayedLessThan(.bang, .playerAttr(.bangsPerTurn)))
                }
            }

            context("no limit per turn") {
                it("should allow multiple bang") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .bang
                            }
                        }
                        .attribute(.weapon, 1)
                        .attribute(.bangsPerTurn, 0)
                        Player("p2")
                    }
                        .playCounters([.bang: 1])

                    // When
                    let action = GameAction.play(.bang, player: "p1")
                    let (result, _) = self.awaitAction(action, choices: ["p2"], state: state)

                    // Assert
                    expect(result) == [
                        .chooseOne(player: "p1", options: [
                            "p2": .playImmediate(.bang, target: "p2", player: "p1")
                        ]),
                        .playImmediate(.bang, target: "p2", player: "p1"),
                        .damage(1, player: "p2")
                    ]
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
                        .attribute(.bangsPerTurn, 1)
                        .attribute(.weapon, 1)
                        Player("p2").attribute(.mustang, 1)
                        Player("p3")
                        Player("p4").attribute(.mustang, 1)
                    }

                    // When
                    let action = GameAction.play(.bang, player: "p1")
                    let (_, error) = self.awaitAction(action, state: state)

                    // Then
                    expect(error) == .noPlayer(.selectReachable)
                }
            }
        }
    }
}
