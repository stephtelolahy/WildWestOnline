//
//  DuelTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct DuelTests {
    // Given
    private var state: GameState {
        GameState.makeBuilderWithCards()
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

    @Test func playDuel_withTargetPassing_shouldDamage() async throws {
        // When
        let action = GameAction.preparePlay(.duel, player: "p1")
        let result = try await dispatch(action, state: state, choose: ["p2", .pass])

        // Then
        #expect(result == [
            .playBrown(.duel, player: "p1"),
            .chooseOne(.target, options: ["p2", "p3", "p4"], player: "p1"),
            .chooseOne(.cardToDiscard, options: [.bang2, .pass], player: "p2"),
            .damage(1, player: "p2")
        ])
    }

    @Test func playDuel_withTargetDiscardingBang_shouldDamageOffender() async throws {
        // When
        let action = GameAction.preparePlay(.duel, player: "p1")
        let result = try await dispatch(action, state: state, choose: ["p2", .bang2, .pass])

        // Then
        #expect(result == [
            .playBrown(.duel, player: "p1"),
            .chooseOne(.target, options: ["p2", "p3", "p4"], player: "p1"),
            .chooseOne(.cardToDiscard, options: [.bang2, .pass], player: "p2"),
            .discardHand(.bang2, player: "p2"),
            .chooseOne(.cardToDiscard, options: [.bang1, .pass], player: "p1"),
            .damage(1, player: "p1")
        ])
    }
}

private extension String {
    static let bang1 = "\(String.bang)-1"
    static let bang2 = "\(String.bang)-2"
}
