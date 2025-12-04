//
//  DuelTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameFeature

struct DuelTests {
    // Given
    private var state: GameFeature.State {
        GameFeature.State.makeBuilder()
            .withAllCards()
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
        let action = GameFeature.Action.preparePlay(.duel, player: "p1")
        let choiceHandler = choiceHandlerWithResponses([
            .init(options: ["p2", "p3", "p4", .choicePass], selection: "p2"),
            .init(options: [.bang2, .choicePass], selection: .choicePass)
        ])
        let result = try await dispatchUntilCompleted(action, state: state, choiceHandler: choiceHandler)

        // Then
        #expect(result == [
            .preparePlay(.duel, player: "p1"),
            .choose("p2", player: "p1"),
            .play(.duel, player: "p1", target: "p2"),
            .choose(.choicePass, player: "p2"),
            .damage(1, player: "p2")
        ])
    }

    @Test func play_withTargetDiscardingBang_shouldDamageOffender() async throws {
        // When
        let action = GameFeature.Action.preparePlay(.duel, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.duel, player: "p1"),
            .choose("p2", player: "p1"),
            .play(.duel, player: "p1", target: "p2"),
            .choose(.bang2, player: "p2"),
            .discardHand(.bang2, player: "p2"),
            .choose(.bang1, player: "p1"),
            .discardHand(.bang1, player: "p1"),
            .damage(1, player: "p2")
        ])
    }
}
