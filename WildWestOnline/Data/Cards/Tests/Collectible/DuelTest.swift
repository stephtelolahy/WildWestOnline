//
//  DuelTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct DuelTests {
    // Given
    private var state: GameState {
        GameState.makeBuilderWithAllCards()
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

    @Test func play_withTargetPassing_shouldDamage() async throws {
        // When
        let action = GameAction.preparePlay(.duel, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2", "p3", "p4"], selectionIndex: 0),
            .init(options: [.bang2, .pass], selectionIndex: 1)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .play(.duel, player: "p1"),
            .choose("p2", player: "p1"),
            .choose(.pass, player: "p2"),
            .damage(1, player: "p2")
        ])
    }

    @Test func play_withTargetDiscardingBang_shouldDamageOffender() async throws {
        // When
        let action = GameAction.preparePlay(.duel, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2", "p3", "p4"], selectionIndex: 0),
            .init(options: [.bang2, .pass], selectionIndex: 0),
            .init(options: [.bang1, .pass], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .play(.duel, player: "p1"),
            .choose("p2", player: "p1"),
            .choose(.bang2, player: "p2"),
            .discardHand(.bang2, player: "p2"),
            .choose(.bang1, player: "p1"),
            .discardHand(.bang1, player: "p1"),
            .damage(1, player: "p2")
        ])
    }
}

private extension String {
    static let bang1 = "\(String.bang)-1"
    static let bang2 = "\(String.bang)-2"
}
