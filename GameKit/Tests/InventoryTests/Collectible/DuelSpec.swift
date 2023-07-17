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
                state = createGameWithCardRef {
                    Player("p1") {
                        Hand {
                            .duel
                            "bang-1"
                        }
                    }
                    Player("p2") {
                        Hand {
                            "bang-2"
                        }
                    }
                    Player("p3")
                    Player("p4")
                }
            }

            context("passing") {
                it("should damage") {
                    // When
                    let action = GameAction.play(.duel, actor: "p1")
                    let result = self.awaitAction(action, choices: ["p2", .pass], state: state)

                    // Then
                    expect(result) == [
                        .chooseOne(player: "p1", options: [
                            "p2": .playImmediate(.duel, target: "p2", actor: "p1"),
                            "p3": .playImmediate(.duel, target: "p3", actor: "p1"),
                            "p4": .playImmediate(.duel, target: "p4", actor: "p1")
                        ]),
                        .playImmediate(.duel, target: "p2", actor: "p1"),
                        .chooseOne(player: "p2", options: [
                            "bang-2": .group([
                                .discard("bang-2", player: "p2"),
                                // swiftlint:disable:next line_length
                                .resolve(.challenge(.id("p2"), effect: .discard(.selectHandNamed(.bang)), otherwise: .damage(1)), ctx: [.actor: "p1", .card: .duel, .target: "p1"])
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
                    let action = GameAction.play(.duel, actor: "p1")
                    let result = self.awaitAction(action, choices: ["p2", "bang-2", .pass], state: state)

                    // Then
                    expect(result) == [
                        .chooseOne(player: "p1", options: [
                            "p2": .playImmediate(.duel, target: "p2", actor: "p1"),
                            "p3": .playImmediate(.duel, target: "p3", actor: "p1"),
                            "p4": .playImmediate(.duel, target: "p4", actor: "p1")
                        ]),
                        .playImmediate(.duel, target: "p2", actor: "p1"),
                        .chooseOne(player: "p2", options: [
                            "bang-2": .group([
                                .discard("bang-2", player: "p2"),
                                // swiftlint:disable:next line_length
                                .resolve(.challenge(.id("p2"), effect: .discard(.selectHandNamed(.bang)), otherwise: .damage(1)), ctx: [.actor: "p1", .card: .duel, .target: "p1"])
                            ]),
                            .pass: .damage(1, player: "p2")
                        ]),
                        .discard("bang-2", player: "p2"),
                        .chooseOne(player: "p1", options: [
                            "bang-1": .group([
                                .discard("bang-1", player: "p1"),
                                // swiftlint:disable:next line_length
                                .resolve(.challenge(.id("p1"), effect: .discard(.selectHandNamed(.bang)), otherwise: .damage(1)), ctx: [.actor: "p1", .card: .duel, .target: "p2"])
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
