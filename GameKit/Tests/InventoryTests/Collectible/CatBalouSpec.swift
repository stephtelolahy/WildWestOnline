//
//  CatBalouSpec.swift
//
//
//  Created by Hugues Telolahy on 10/04/2023.
//

import Game
import Nimble
import Quick

final class CatBalouSpec: QuickSpec {
    override func spec() {
        describe("playing catBalou") {
            context("no player allowed") {
                it("should throw error") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.catBalou])
                        }
                        .build()

                    // When
                    let action = GameAction.play(.catBalou, player: "p1")
                    let (_, error) = self.awaitAction(action, state: state)

                    // Then
                    expect(error) == .noPlayer(.selectAny)
                }
            }

            context("target is other") {
                context("having hand cards") {
                    it("should choose one random hand card") {
                        // Given
                        let state = GameState.makeBuilderWithCardRef()
                            .withPlayer("p1") {
                                $0.withHand([.catBalou])
                            }
                            .withPlayer("p2") {
                                $0.withHand(["c21"])
                            }
                            .build()

                        // When
                        let action = GameAction.play(.catBalou, player: "p1")
                        let (result, _) = self.awaitAction(action, state: state, choose: ["p2", .randomHand])

                        // Then
                        expect(result) == [
                            .chooseOne(player: "p1", options: [
                                "p2": .playImmediate(.catBalou, target: "p2", player: "p1")
                            ]),
                            .playImmediate(.catBalou, target: "p2", player: "p1"),
                            .chooseOne(player: "p1", options: [
                                .randomHand: .discardHand("c21", player: "p2")
                            ]),
                            .discardHand("c21", player: "p2")
                        ]
                    }
                }

                context("having inPlay cards") {
                    it("should choose one inPlay card") {
                        // Given
                        let state = GameState.makeBuilderWithCardRef()
                            .withPlayer("p1") {
                                $0.withHand([.catBalou])
                            }
                            .withPlayer("p2") {
                                $0.withInPlay(["c21", "c22"])
                            }
                            .build()

                        // When
                        let action = GameAction.play(.catBalou, player: "p1")
                        let (result, _) = self.awaitAction(action, state: state, choose: ["p2", "c22"])

                        // Then
                        expect(result) == [
                            .chooseOne(player: "p1", options: [
                                "p2": .playImmediate(.catBalou, target: "p2", player: "p1")
                            ]),
                            .playImmediate(.catBalou, target: "p2", player: "p1"),
                            .chooseOne(player: "p1", options: [
                                "c21": .discardInPlay("c21", player: "p2"),
                                "c22": .discardInPlay("c22", player: "p2")
                            ]),
                            .discardInPlay("c22", player: "p2")
                        ]
                    }
                }

                context("having hand and inPlay cards") {
                    it("should choose one inPlay or random hand card") {
                        // Given
                        let state = GameState.makeBuilderWithCardRef()
                            .withPlayer("p1") {
                                $0.withHand([.catBalou])
                            }
                            .withPlayer("p2") {
                                $0.withHand(["c21"])
                                    .withInPlay(["c22", "c23"])
                            }
                            .build()

                        // When
                        let action = GameAction.play(.catBalou, player: "p1")
                        let (result, _) = self.awaitAction(action, state: state, choose: ["p2", "c23"])

                        // Then
                        expect(result) == [
                            .chooseOne(player: "p1", options: [
                                "p2": .playImmediate(.catBalou, target: "p2", player: "p1")
                            ]),
                            .playImmediate(.catBalou, target: "p2", player: "p1"),
                            .chooseOne(player: "p1", options: [
                                .randomHand: .discardHand("c21", player: "p2"),
                                "c22": .discardInPlay("c22", player: "p2"),
                                "c23": .discardInPlay("c23", player: "p2")
                            ]),
                            .discardInPlay("c23", player: "p2")
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
