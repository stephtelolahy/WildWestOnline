//
//  ElGringoSpec.swift
//
//
//  Created by Hugues Telolahy on 04/11/2023.
//
import Quick
import Nimble
import Game

final class ElGringoSpec: QuickSpec {
    override func spec() {
        describe("ElGringo being damaged") {
            context("offender has several hand cards") {
                it("should steal one random card") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withAttributes([.elGringo: 0])
                                .withHealth(3)
                        }
                        .withPlayer("p2") {
                            $0.withHand([.bang, "c2", "c2"])
                        }
                        .withTurn("p2")
                        .build()

                    // When
                    let action = GameAction.playImmediate(.bang, target: "p1", player: "p2")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playImmediate(.bang, target: "p1", player: "p2"),
                        .damage(1, player: "p1"),
                        .stealHand("c2", target: "p2", player: "p1")
                    ]
                }
            }

            context("offender has no cards") {
                it("should do nothing") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withAttributes([.elGringo: 0])
                                .withHealth(3)
                        }
                        .withPlayer("p2") {
                            $0.withHand([.bang])
                        }
                        .withTurn("p2")
                        .build()

                    // When
                    let action = GameAction.playImmediate(.bang, target: "p1", player: "p2")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playImmediate(.bang, target: "p1", player: "p2"),
                        .damage(1, player: "p1")
                    ]
                }
            }

            context("offender is himself") {
                it("should do nothing") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withAttributes([.elGringo: 0])
                                .withHealth(3)
                        }
                        .withTurn("p1")
                        .build()

                    // When
                    let action = GameAction.damage(1, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .damage(1, player: "p1")
                    ]
                }
            }
        }
    }
}
