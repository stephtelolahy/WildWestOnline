//
//  EndTurnSpec.swift
//  
//
//  Created by Hugues Telolahy on 01/05/2023.
//

import Game
import Nimble
import Quick

final class EndTurnSpec: QuickSpec {
    override func spec() {
        describe("ending turn") {
            context("no excess cards") {
                it("should discard nothing") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withAttributes([.endTurn: 0])
                        }
                        .withPlayer("p2")
                        .withTurn("p1")
                        .build()

                    // When
                    let action = GameAction.play(.endTurn, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playAbility(.endTurn, player: "p1"),
                        .setTurn("p2")
                    ]
                }
            }

            context("custom hand limit") {
                it("should discard nothing") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand(["c1", "c2"])
                                .withHealth(1)
                                .withAttributes([.endTurn: 0, .handLimit: 10])
                        }
                        .withPlayer("p2")
                        .withTurn("p1")
                        .build()

                    // When
                    let action = GameAction.play(.endTurn, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playAbility(.endTurn, player: "p1"),
                        .setTurn("p2")
                    ]
                }
            }

            context("having one excess card") {
                it("should discard a hand card") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand(["c1", "c2", "c3"])
                                .withHealth(2)
                                .withAttributes([.endTurn: 0])
                        }
                        .withPlayer("p2")
                        .withTurn("p1")
                        .build()

                    // When
                    let action = GameAction.play(.endTurn, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state, choose: ["c1"])

                    // Then
                    expect(result) == [
                        .playAbility(.endTurn, player: "p1"),
                        .chooseOne(player: "p1", options: [
                            "c1": .discardHand("c1", player: "p1"),
                            "c2": .discardHand("c2", player: "p1"),
                            "c3": .discardHand("c3", player: "p1")
                        ]),
                        .discardHand("c1", player: "p1"),
                        .setTurn("p2")
                    ]
                }
            }

            context("having 2 excess cards") {
                it("should discard 2 hand cards") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand(["c1", "c2", "c3"])
                                .withHealth(1)
                                .withAttributes([.endTurn: 0])
                        }
                        .withPlayer("p2")
                        .withTurn("p1")
                        .build()

                    // When
                    let action = GameAction.play(.endTurn, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state, choose: ["c1", "c3"])

                    // Then
                    expect(result) == [
                        .playAbility(.endTurn, player: "p1"),
                        .chooseOne(player: "p1", options: [
                            "c1": .discardHand("c1", player: "p1"),
                            "c2": .discardHand("c2", player: "p1"),
                            "c3": .discardHand("c3", player: "p1")
                        ]),
                        .discardHand("c1", player: "p1"),
                        .chooseOne(player: "p1", options: [
                            "c2": .discardHand("c2", player: "p1"),
                            "c3": .discardHand("c3", player: "p1")
                        ]),
                        .discardHand("c3", player: "p1"),
                        .setTurn("p2")
                    ]
                }
            }
        }
    }
}
