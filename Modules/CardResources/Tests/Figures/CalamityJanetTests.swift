//
//  CalamityJanetTest.swift
//
//
//  Created by Hugues Telolahy on 20/11/2023.
//

import GameFeature
import Testing

struct CalamityJanetTests {
    @Test func playingBang_shouldShoot() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.calamityJanet])
                    .withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2", .choicePass], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .choose("p2", player: "p1"),
            .play(.bang, player: "p1", target: "p2"),
            .shoot("p2"),
            .damage(1, player: "p2")
        ])
    }

    @Test func playingMissed_shouldShoot() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.calamityJanet])
                    .withHand([.missed])
                    .withWeapon(1)
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.missed, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2", .choicePass], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .choose("p2", player: "p1"),
            .play(.missed, player: "p1", target: "p2"),
            .shoot("p2"),
            .damage(1, player: "p2")
        ])
    }

    @Test func beingShot_holdingBang_shouldAskToCounter() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.calamityJanet])
                    .withHand([.missed])
                    .withAbilities([.discardMissedOnShot])
            }
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let choices: [Choice] = [
            .init(options: [.missed, .choicePass], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .shoot("p1"),
            .choose(.missed, player: "p1"),
            .discardHand(.missed, player: "p1"),
            .counterShoot(player: "p1")
        ])
    }

    @Test func beingShot_holdingMissed_shouldAskToCounter() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.calamityJanet])
                    .withHand([.bang])
                    .withAbilities([.discardMissedOnShot])
            }
            .build()

        // When
        let action = GameFeature.Action.shoot("p1")
        let choices: [Choice] = [
            .init(options: [.bang, .choicePass], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .shoot("p1"),
            .choose(.bang, player: "p1"),
            .discardHand(.bang, player: "p1"),
            .counterShoot(player: "p1")
        ])
    }
}
