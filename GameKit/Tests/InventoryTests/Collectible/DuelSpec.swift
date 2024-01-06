//
//  DuelSpec.swift
//
//
//  Created by Hugues Telolahy on 26/04/2023.
//

import Game
import Inventory
import Nimble
import Quick

final class DuelSpec: QuickSpec {
    override func spec() {
        var state: GameState!

        describe("playing Duel") {
            beforeEach {
                state = GameState.makeBuilderWithCardRef()
                    .withPlayer("p1") {
                        $0.withHand([.duel, .bang1])
                    }
                    .withPlayer("p2") {
                        $0.withHand([.bang2])
                    }
                    .withPlayer("p3")
                    .withPlayer("p4")
                    .build()
            }

            context("passing") {
                it("should damage") {
                    // When
                    let action = GameAction.play(.duel, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state, choose: ["p2", .pass])

                    // Then
                    expect(result) == [
                        .chooseOne([
                            "p2": .play(.duel, target: "p2", player: "p1"),
                            "p3": .play(.duel, target: "p3", player: "p1"),
                            "p4": .play(.duel, target: "p4", player: "p1")
                        ], player: "p1"),
                        .play(.duel, target: "p2", player: "p1"),
                        .chooseOne([
                            .bang2: .group([
                                .discardHand(.bang2, player: "p2"),
                                .effect(.challenge(.id("p2"),
                                                   effect: .discard(.selectHandNamed(.bang)),
                                                   otherwise: .damage(1)
                                                  ),
                                        ctx: EffectContext(
                                            actor: "p1",
                                            card: .duel,
                                            event: .play(.duel, target: "p2", player: "p1"), target: "p1")
                                )
                            ]),
                            .pass: .damage(1, player: "p2")
                        ], player: "p2"),
                        .damage(1, player: "p2")
                    ]
                }
            }

            context("discarding bang") {
                it("should damage actor") {
                    // When
                    let action = GameAction.play(.duel, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state, choose: ["p2", .bang2, .pass])

                    // Then
                    expect(result) == [
                        .chooseOne([
                            "p2": .play(.duel, target: "p2", player: "p1"),
                            "p3": .play(.duel, target: "p3", player: "p1"),
                            "p4": .play(.duel, target: "p4", player: "p1")
                        ], player: "p1"),
                        .play(.duel, target: "p2", player: "p1"),
                        .chooseOne([
                            .bang2: .group([
                                .discardHand(.bang2, player: "p2"),
                                .effect(.challenge(.id("p2"),
                                                   effect: .discard(.selectHandNamed(.bang)),
                                                   otherwise: .damage(1)
                                                  ),
                                        ctx: EffectContext(
                                            actor: "p1",
                                            card: .duel,
                                            event: .play(.duel, target: "p2", player: "p1"), target: "p1")
                                )
                            ]),
                            .pass: .damage(1, player: "p2")
                        ], player: "p2"),
                        .discardHand(.bang2, player: "p2"),
                        .chooseOne([
                            .bang1: .group([
                                .discardHand(.bang1, player: "p1"),
                                .effect(.challenge(.id("p1"),
                                                   effect: .discard(.selectHandNamed(.bang)),
                                                   otherwise: .damage(1)
                                                  ),
                                        ctx: EffectContext(
                                            actor: "p1",
                                            card: .duel,
                                            event: .play(.duel, target: "p2", player: "p1"), target: "p2")
                                )
                            ]),
                            .pass: .damage(1, player: "p1")
                        ], player: "p1"),
                        .damage(1, player: "p1")
                    ]
                }
            }
        }
    }
}

private extension String {
    static let bang1 = "\(String.bang)-1"
    static let bang2 = "\(String.bang)-2"
}
