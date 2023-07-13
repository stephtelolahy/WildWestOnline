//
//  EndTurnSpec.swift
//  
//
//  Created by Hugues Telolahy on 01/05/2023.
//

import Quick
import Nimble
import Game

final class EndTurnSpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("ending turn") {
            context("no excess cards") {
                it("should discard nothing") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1")
                        Player("p2")
                    }
                    .turn("p1")

                    // When
                    let action = GameAction.play(.endTurn, actor: "p1")
                    let result = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playAbility(.endTurn, actor: "p1"),
                        .setTurn("p2")
                    ]
                }
            }

            context("custom hand limit") {
                it("should discard nothing") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                "c1"
                                "c2"
                            }
                        }
                        .attribute(.health, 1)
                        .attribute(.handLimit, 10)
                        Player("p2")
                    }
                    .turn("p1")

                    // When
                    let action = GameAction.play(.endTurn, actor: "p1")
                    let result = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playAbility(.endTurn, actor: "p1"),
                        .setTurn("p2")
                    ]
                }
            }

            context("having one excess card") {
                it("should discard a hand card") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                "c1"
                                "c2"
                                "c3"
                            }
                        }
                        .attribute(.health, 2)
                        Player("p2")
                    }
                    .turn("p1")

                    // When
                    let action = GameAction.play(.endTurn, actor: "p1")
                    let result = self.awaitAction(action, choices: ["c1"], state: state)

                    // Then
                    expect(result) == [
                        .playAbility(.endTurn, actor: "p1"),
                        .chooseOne(player: "p1", options: [
                            "c1": .discard("c1", player: "p1"),
                            "c2": .discard("c2", player: "p1"),
                            "c3": .discard("c3", player: "p1")
                        ]),
                        .discard("c1", player: "p1"),
                        .setTurn("p2")
                    ]
                }
            }

            context("having 2 excess cards") {
                it("should discard 2 hand cards") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                "c1"
                                "c2"
                                "c3"
                            }
                        }
                        .attribute(.health, 1)
                        Player("p2")
                    }
                    .turn("p1")

                    // When
                    let action = GameAction.play(.endTurn, actor: "p1")
                    let result = self.awaitAction(action, choices: ["c1", "c3"], state: state)

                    // Then
                    expect(result) == [
                        .playAbility(.endTurn, actor: "p1"),
                        .chooseOne(player: "p1", options: [
                            "c1": .discard("c1", player: "p1"),
                            "c2": .discard("c2", player: "p1"),
                            "c3": .discard("c3", player: "p1")
                        ]),
                        .discard("c1", player: "p1"),
                        .chooseOne(player: "p1", options: [
                            "c2": .discard("c2", player: "p1"),
                            "c3": .discard("c3", player: "p1")
                        ]),
                        .discard("c3", player: "p1"),
                        .setTurn("p2")
                    ]
                }
            }
        }
    }
}
