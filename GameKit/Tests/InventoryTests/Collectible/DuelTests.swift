//
//  DuelTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Game
import Inventory
import XCTest

final class DuelTests: XCTestCase {
    // Given
    private var state: GameState {
        GameState.makeBuilderWithCardRef()
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

    func test_playDuel_withTargetPassing_shouldDamage() {
        // When
        let action = GameAction.play(.duel, player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2", .pass])

        // Then
        XCTAssertEqual(result, [
            .play(.duel, player: "p1"),
            .chooseOne([
                "p2": .nothing,
                "p3": .nothing,
                "p4": .nothing
            ], player: "p1"),
            .chooseOne([
                .bang2: .group([
                    .discardHand(.bang2, player: "p2"),
                    .effect(
                        .challenge(.id("p2"),
                                   effect: .discard(.selectHandNamed(.bang)),
                                   otherwise: .damage(1)
                                  ),
                        ctx: EffectContext(
                            actor: "p1",
                            card: .duel,
                            event: .play(.duel, player: "p1")
                        )
                    )
                ]),
                .pass: .damage(1, player: "p2")
            ], player: "p2"),
            .damage(1, player: "p2")
        ])
    }

    func test_playDuel_withTargetDiscardingBang_shouldDamageOffender() {
        // When
        let action = GameAction.play(.duel, player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2", .bang2, .pass])

        // Then
        XCTAssertEqual(result, [
            .play(.duel, player: "p1"),
            .chooseOne([
                "p2": .nothing,
                "p3": .nothing,
                "p4": .nothing
            ], player: "p1"),
            .chooseOne([
                .bang2: .group([
                    .discardHand(.bang2, player: "p2"),
                    .effect(
                        .challenge(.id("p2"),
                                   effect: .discard(.selectHandNamed(.bang)),
                                   otherwise: .damage(1)
                                  ),
                        ctx: EffectContext(
                            actor: "p1",
                            card: .duel,
                            event: .play(.duel, player: "p1")
                        )
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
                                event: .play(.duel, player: "p1")
                            )
                    )
                ]),
                .pass: .damage(1, player: "p1")
            ], player: "p1"),
            .damage(1, player: "p1")
        ])
    }
}

private extension String {
    static let bang1 = "\(String.bang)-1"
    static let bang2 = "\(String.bang)-2"
}
