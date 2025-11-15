//
//  SlabTheKillerTest.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 29/05/2024.
//

import CardResources
import GameFeature
import Testing

struct SlabTheKillerTests {
    @Test func playingBang_shouldRequiresTwoMisses() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.slabTheKiller])
                    .withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2") {
                $0.withHand([.missed1, .missed2])
                    .withAbilities([.discardMissedOnShot])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2", .choicePass], selectionIndex: 0),
            .init(options: [.missed1, .missed2, .choicePass], selectionIndex: 0),
            .init(options: [.missed2, .choicePass], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(
            result == [
                .choose("p2", player: "p1"),
                .play(.bang, player: "p1", target: "p2"),
                .shoot("p2"),
                .choose(.missed1, player: "p2"),
                .discardHand(.missed1, player: "p2"),
                .choose(.missed2, player: "p2"),
                .discardHand(.missed2, player: "p2"),
                .counterShoot(player: "p2")
            ])
    }

    @Test func playingBang_withOneCounter_shouldDamage() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.slabTheKiller])
                    .withHand([.bang])
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
            .init(options: [.missed, .choicePass], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(
            result == [
                .choose("p2", player: "p1"),
                .play(.bang, player: "p1", target: "p2"),
                .shoot("p2"),
                .choose(.missed, player: "p2"),
                .discardHand(.missed, player: "p2"),
                .damage(1, player: "p2")
            ])
    }
}

private extension String {
    static let missed1 = "\(String.missed)-1"
    static let missed2 = "\(String.missed)-2"
}
