//
//  MissedTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 12/10/2023.
//

import Testing
import GameFeature

struct MissedTest {
    @Test func beingShot_discardingMissed_shouldCounter() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2") {
                $0.withHand([.missed1, .missed2, .beer])
                    .withAbilities([.discardMissedOnShot])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2", .choicePass], selectionIndex: 0),
            .init(options: [.missed1, .missed2, .choicePass], selectionIndex: 1)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .choose("p2", player: "p1"),
            .play(.bang, player: "p1", target: "p2"),
            .shoot("p2"),
            .choose(.missed2, player: "p2"),
            .discardHand(.missed2, player: "p2"),
            .counterShoot(player: "p2")
        ])
    }

    @Test func beingShot_choosingPass_shouldDealDamage() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2") {
                $0.withHand([.missed])
                    .withAbilities([.discardMissedOnShot])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2", .choicePass], selectionIndex: 0),
            .init(options: [.missed, .choicePass], selectionIndex: 1)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .choose("p2", player: "p1"),
            .play(.bang, player: "p1", target: "p2"),
            .shoot("p2"),
            .choose(.choicePass, player: "p2"),
            .damage(1, player: "p2")
        ])
    }

    @Test func beingShot_noCounterCard_shouldDealDamage() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2") {
                $0.withAbilities([.discardMissedOnShot])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2", .choicePass], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices, ignoreError: true)

        // Then
        #expect(result == [
            .choose("p2", player: "p1"),
            .play(.bang, player: "p1", target: "p2"),
            .shoot("p2"),
            .damage(1, player: "p2")
        ])
    }
}

private extension String {
    static let missed1 = "\(String.missed)-1"
    static let missed2 = "\(String.missed)-2"
}
