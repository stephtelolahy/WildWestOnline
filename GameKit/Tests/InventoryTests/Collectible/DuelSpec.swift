//
//  DuelSpec.swift
//
//
//  Created by Hugues Telolahy on 26/04/2023.
//

import Quick
import Nimble
import Game

final class DuelSpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        var state: GameState!

        describe("playing Duel") {
            beforeEach {
                state = GameState.makeBuilderWithCardRef()
                    .withPlayer("p1") {
                        $0.withHand([.duel, "bang-1"])
                    }
                    .withPlayer("p2") {
                        $0.withHand(["bang-2"])
                    }
                    .withPlayer("p3")
                    .withPlayer("p4")
                    .build()
            }

            context("passing") {
                it("should damage") {
                    // When
                    let action = GameAction.play(.duel, player: "p1")
                    let (result, _) = self.awaitAction(action, choices: ["p2", .pass], state: state)

                    // Then
                    expect(result) == [
                        .chooseOne(player: "p1", options: [
                            "p2": .playImmediate(.duel, target: "p2", player: "p1"),
                            "p3": .playImmediate(.duel, target: "p3", player: "p1"),
                            "p4": .playImmediate(.duel, target: "p4", player: "p1")
                        ]),
                        .playImmediate(.duel, target: "p2", player: "p1"),
                        .chooseOne(player: "p2", options: [
                            "bang-2": .group([
                                .discardHand("bang-2", player: "p2"),
                                // swiftlint:disable:next line_length
                                .effect(.challenge(.id("p2"), effect: .discard(.selectHandNamed(.bang)), otherwise: .damage(1)), ctx: EffectContext(actor: "p1", card: .duel, event: .playImmediate(.duel, target: "p2", player: "p1"), target: "p1"))
                            ]),
                            .pass: .damage(1, player: "p2")
                        ]),
                        .damage(1, player: "p2")
                    ]
                }
            }

            context("discarding bang") {
                it("should damage actor") {
                    // When
                    let action = GameAction.play(.duel, player: "p1")
                    let (result, _) = self.awaitAction(action, choices: ["p2", "bang-2", .pass], state: state)

                    // Then
                    expect(result) == [
                        .chooseOne(player: "p1", options: [
                            "p2": .playImmediate(.duel, target: "p2", player: "p1"),
                            "p3": .playImmediate(.duel, target: "p3", player: "p1"),
                            "p4": .playImmediate(.duel, target: "p4", player: "p1")
                        ]),
                        .playImmediate(.duel, target: "p2", player: "p1"),
                        .chooseOne(player: "p2", options: [
                            "bang-2": .group([
                                .discardHand("bang-2", player: "p2"),
                                // swiftlint:disable:next line_length
                                .effect(.challenge(.id("p2"), effect: .discard(.selectHandNamed(.bang)), otherwise: .damage(1)), ctx: EffectContext(actor: "p1", card: .duel, event: .playImmediate(.duel, target: "p2", player: "p1"), target: "p1"))
                            ]),
                            .pass: .damage(1, player: "p2")
                        ]),
                        .discardHand("bang-2", player: "p2"),
                        .chooseOne(player: "p1", options: [
                            "bang-1": .group([
                                .discardHand("bang-1", player: "p1"),
                                // swiftlint:disable:next line_length
                                .effect(.challenge(.id("p1"), effect: .discard(.selectHandNamed(.bang)), otherwise: .damage(1)), ctx: EffectContext(actor: "p1", card: .duel, event: .playImmediate(.duel, target: "p2", player: "p1"), target: "p2"))
                            ]),
                            .pass: .damage(1, player: "p1")
                        ]),
                        .damage(1, player: "p1")
                    ]
                }
            }
        }
    }
}
