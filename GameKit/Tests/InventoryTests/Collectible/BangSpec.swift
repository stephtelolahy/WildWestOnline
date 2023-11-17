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
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.bang])
                                .withAttributes([.bangsPerTurn: 1, .weapon: 1])
                        }
                        .withPlayer("p2")
                        .build()

                    // When
                    let action = GameAction.play(.bang, player: "p1")
                    let (result, _) = self.awaitAction(action, choose: ["p2"], state: state)

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
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.bang])
                                .withAttributes([.weapon: 1, .bangsPerTurn: 1])
                        }
                        .withPlayer("p2")
                        .withPlayedThisTurn([.bang: 1])
                        .build()

                    // When
                    let action = GameAction.play(.bang, player: "p1")
                    let (_, error) = self.awaitAction(action, state: state)

                    // Assert
                    expect(error) == .noReq(.isCardPlayedLessThan(.bang, .attr(.bangsPerTurn)))
                }
            }

            context("no limit per turn") {
                it("should allow multiple bang") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.bang])
                                .withAttributes([.weapon: 1, .bangsPerTurn: 0])
                        }
                        .withPlayer("p2")
                        .withPlayedThisTurn([.bang: 1])
                        .build()

                    // When
                    let action = GameAction.play(.bang, player: "p1")
                    let (result, _) = self.awaitAction(action, choose: ["p2"], state: state)

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
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.bang])
                                .withAttributes([.bangsPerTurn: 1, .weapon: 1])
                        }
                        .withPlayer("p2") {
                            $0.withAttributes([.mustang: 1])
                        }
                        .build()

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
