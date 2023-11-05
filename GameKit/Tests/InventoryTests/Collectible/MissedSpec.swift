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
            context("not being targeted by shoot") {
                it("should throw error") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.missed])
                        }
                        .withTurn("p1")
                        .build()

                    // When
                    let action = GameAction.play(.missed, player: "p1")
                    let (_, error) = self.awaitAction(action, state: state)

                    // Then
                    expect(error) == .noEffectToCancel(.effectOfShoot)

                }
            }
        }

        describe("triggering missed") {
            context("bang") {
                context("holding a missed card") {
                    it("should ask choice") {
                        // Given
                        let state = GameState.makeBuilderWithCardRef()
                            .withPlayer("p1") {
                                $0.withHand([.bang])
                                    .withAttributes([.bangsPerTurn: 1, .weapon: 1])
                            }
                            .withPlayer("p2") {
                                $0.withHand([.missed])
                            }
                            .build()

                        // When
                        let action = GameAction.playImmediate(.bang, target: "p2", player: "p1")
                        let (result, _) = self.awaitAction(action, choose: [.missed], state: state)

                        // Then
                        expect(result) == [
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
                        let state = GameState.makeBuilderWithCardRef()
                            .withPlayer("p1") {
                                $0.withHand([.bang])
                                    .withAttributes([.bangsPerTurn: 1, .weapon: 1])
                            }
                            .withPlayer("p2") {
                                $0.withHand([.missed, "missed-2", "missed-3"])
                            }
                            .build()

                        // When
                        let action = GameAction.playImmediate(.bang, target: "p2", player: "p1")
                        let (result, _) = self.awaitAction(action, choose: [.missed], state: state)

                        // Then
                        expect(result) == [
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
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.gatling])
                        }
                        .withPlayer("p2") {
                            $0.withHand([.missed])
                        }
                        .withPlayer("p3") {
                            $0.withHand([.missed])
                        }
                        .withDeck(["c1", "c2", "c3"])
                        .build()

                    // When
                    let action = GameAction.play(.gatling, player: "p1")
                    let (result, _) = self.awaitAction(action, choose: [.missed, .missed], state: state)

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
