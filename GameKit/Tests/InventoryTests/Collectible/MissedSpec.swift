//
//  MissedSpec.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 12/10/2023.
//

import Quick
import Nimble
import Game

final class MissedSpec: QuickSpec {
    override func spec() {
        describe("playing missed") {
            context("your turn") {
                it("should throw error") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .missed
                            }
                        }
                    }
                    .turn("p1")

                    // When
                    let action = GameAction.play(.missed, player: "p1")
                    let (_, error) = self.awaitAction(action, state: state)

                    // Then
                    expect(error) == .noReq(.isOutOfTurn)

                }
            }
        }

        describe("triggering missed") {
            context("bang") {
                context("holding a missed card") {
                    it("should ask choice") {
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
                                }
                            }
                        }

                        // When
                        let action = GameAction.play(.bang, player: "p1")
                        let (result, _) = self.awaitAction(action, choices: ["p2", .missed], state: state)

                        // Then
                        expect(result) == [
                            .chooseOne(player: "p1", options: [
                                "p2": .playImmediate(.bang, target: "p2", player: "p1")
                            ]),
                            .playImmediate(.bang, target: "p2", player: "p1"),
                            .chooseOne(player: "p2", options: [
                                .missed: .play(.missed, player: "p2"),
                                .pass: .group([])
                            ]),
                            .playImmediate(.missed, player: "p2"),
                            .cancel(.damage(1, player: "p2"))
                        ]

                    }
                }

                context("holding multiple missed cards") {
                    it("should ask choice once") {
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
                                    "missed-3"
                                }
                            }
                        }

                        // When
                        let action = GameAction.play(.bang, player: "p1")
                        let (result, _) = self.awaitAction(action, choices: ["p2", .missed], state: state)

                        // Then
                        expect(result) == [
                            .chooseOne(player: "p1", options: [
                                "p2": .playImmediate(.bang, target: "p2", player: "p1")
                            ]),
                            .playImmediate(.bang, target: "p2", player: "p1"),
                            .chooseOne(player: "p2", options: [
                                .missed: .play(.missed, player: "p2"),
                                .pass: .group([])
                            ]),
                            .playImmediate(.missed, player: "p2"),
                            .cancel(.damage(1, player: "p2"))
                        ]

                    }
                }
            }

            context("gatling") {
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
                        Player("p3") {
                            Hand {
                                .missed
                            }
                        }
                    }

                    // When
                    let action = GameAction.play(.gatling, player: "p1")
                    let (result, _) = self.awaitAction(action, choices: [.missed, .missed], state: state)

                    // Then
                    expect(result) == [
                        .playImmediate(.gatling, player: "p1"),
                        .chooseOne(player: "p2", options: [
                            .missed: .play(.missed, player: "p2"),
                            .pass: .group([])
                        ]),
                        .playImmediate(.missed, player: "p2"),
                        .cancel(.damage(1, player: "p2")),
                        .chooseOne(player: "p3", options: [
                            .missed: .play(.missed, player: "p3"),
                            .pass: .group([])
                        ]),
                        .playImmediate(.missed, player: "p3"),
                        .cancel(.damage(1, player: "p3"))
                    ]
                }
            }
        }
    }
}
