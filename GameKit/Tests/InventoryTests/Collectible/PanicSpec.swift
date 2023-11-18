//
//  PanicSpec.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//

import Game
import Nimble
import Quick

final class PanicSpec: QuickSpec {
    override func spec() {
        describe("playing Panic") {
            context("no player allowed") {
                it("should throw error") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.panic])
                        }
                        .build()

                    // When
                    let action = GameAction.play(.panic, player: "p1")
                    let (_, error) = self.awaitAction(action, state: state)

                    // Then
                    expect(error) == .noPlayer(.selectAt(1))
                }
            }

            context("target is other") {
                context("having hand cards") {
                    it("should choose one random hand card") {
                        // Given
                        let state = GameState.makeBuilderWithCardRef()
                            .withPlayer("p1") {
                                $0.withHand([.panic])
                            }
                            .withPlayer("p2") {
                                $0.withHand(["c21"])
                            }
                            .build()

                        // When
                        let action = GameAction.play(.panic, player: "p1")
                        let (result, _) = self.awaitAction(action, state: state, choose: ["p2", .randomHand])

                        // Then
                        expect(result) == [
                            .chooseOne(player: "p1", options: [
                                "p2": .playImmediate(.panic, target: "p2", player: "p1")
                            ]),
                            .playImmediate(.panic, target: "p2", player: "p1"),
                            .chooseOne(player: "p1", options: [
                                .randomHand: .stealHand("c21", target: "p2", player: "p1")
                            ]),
                            .stealHand("c21", target: "p2", player: "p1")
                        ]
                    }
                }

                context("having inPlay cards") {
                    it("should choose one inPlay card") {
                        // Given
                        let state = GameState.makeBuilderWithCardRef()
                            .withPlayer("p1") {
                                $0.withHand([.panic])
                            }
                            .withPlayer("p2") {
                                $0.withInPlay(["c21", "c22"])
                            }
                            .build()

                        // When
                        let action = GameAction.play(.panic, player: "p1")
                        let (result, _) = self.awaitAction(action, state: state, choose: ["p2", "c22"])

                        // Then
                        expect(result) == [
                            .chooseOne(player: "p1", options: [
                                "p2": .playImmediate(.panic, target: "p2", player: "p1")
                            ]),
                            .playImmediate(.panic, target: "p2", player: "p1"),
                            .chooseOne(player: "p1", options: [
                                "c21": .stealInPlay("c21", target: "p2", player: "p1"),
                                "c22": .stealInPlay("c22", target: "p2", player: "p1")
                            ]),
                            .stealInPlay("c22", target: "p2", player: "p1")
                        ]
                    }
                }

                context("having hand and inPlay cards") {
                    it("should choose one inPlay or random hand card") {
                        // Given
                        let state = GameState.makeBuilderWithCardRef()
                            .withPlayer("p1") {
                                $0.withHand([.panic])
                            }
                            .withPlayer("p2") {
                                $0.withHand(["c21"])
                                    .withInPlay(["c22", "c23"])
                            }
                            .build()

                        // When
                        let action = GameAction.play(.panic, player: "p1")
                        let (result, _) = self.awaitAction(action, choose: ["p2", "c23"], state: state)

                        // Then
                        expect(result) == [
                            .chooseOne(player: "p1", options: [
                                "p2": .playImmediate(.panic, target: "p2", player: "p1")
                            ]),
                            .playImmediate(.panic, target: "p2", player: "p1"),
                            .chooseOne(player: "p1", options: [
                                .randomHand: .stealHand("c21", target: "p2", player: "p1"),
                                "c22": .stealInPlay("c22", target: "p2", player: "p1"),
                                "c23": .stealInPlay("c23", target: "p2", player: "p1")
                            ]),
                            .stealInPlay("c23", target: "p2", player: "p1")
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
