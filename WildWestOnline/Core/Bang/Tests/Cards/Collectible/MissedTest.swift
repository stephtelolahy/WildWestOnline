//
//  MissedTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 12/10/2023.
//

import Testing
import Bang

struct MissedTest {
    @Test func beingShot_discardingMissed_shouldCounter() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2") {
                $0.withHand([.missed1, .missed2, .beer])
            }
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2"], selectionIndex: 0),
            .init(options: [.missed1, .missed2, .pass], selectionIndex: 1)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
                .play(.bang, player: "p1"),
                .choose("p2", player: "p1"),
                .shoot("p2", player: "p1"),
                .choose(.missed2, player: "p2"),
                .discard(.missed2, player: "p2")
        ])
    }

    @Test func beingShot_choosingPass_shouldDealDamage() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2") {
                $0.withHand([.missed])
            }
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2"], selectionIndex: 0),
            .init(options: [.missed, .pass], selectionIndex: 1)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
                .play(.bang, player: "p1"),
                .choose("p2", player: "p1"),
                .shoot("p2", player: "p1"),
                .choose(.pass, player: "p2"),
                .damage(1, player: "p2")
        ])
    }
}

private extension String {
    static let missed1 = "\(String.missed)-1"
    static let missed2 = "\(String.missed)-2"
}
