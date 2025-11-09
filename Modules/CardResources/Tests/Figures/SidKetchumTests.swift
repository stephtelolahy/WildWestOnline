//
//  SidKetchumTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameFeature
import Testing

struct SidKetchumTests {
    @Test func playing_SidKetchum_havingTwoCards_shouldDiscardThemAndGainHealth() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.sidKetchum])
                    .withMaxHealth(4)
                    .withHealth(1)
                    .withHand(["c1", "c2"])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.sidKetchum, player: "p1")
        let choices: [Choice] = [
            .init(options: ["c1", "c2", .choicePass], selectionIndex: 0),
            .init(options: ["c2", .choicePass], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .choose("c2", player: "p1"),
            .discardHand("c2", player: "p1"),
            .heal(1, player: "p1")
        ])
    }

    @Test func playing_SidKetchum_havingThreeCards_shouldDiscardTwoCardsAndGainHealth() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.sidKetchum])
                    .withMaxHealth(4)
                    .withHealth(1)
                    .withHand(["c1", "c2", "c3"])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.sidKetchum, player: "p1")
        let choices: [Choice] = [
            .init(options: ["c1", "c2", "c3", .choicePass], selectionIndex: 0),
            .init(options: ["c2", "c3", .choicePass], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .choose("c2", player: "p1"),
            .discardHand("c2", player: "p1"),
            .heal(1, player: "p1")
        ])
    }

    @Test func playing_SidKetchum_withoutCard_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.sidKetchum])
                    .withMaxHealth(4)
                    .withHealth(1)
            }
            .build()


        // When
        // Then
        let action = GameFeature.Action.preparePlay(.sidKetchum, player: "p1")
        await #expect(throws: GameFeature.Error.noChoosableCard([.isFromHand])) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }

    @Test func playing_SidKetchum_alreadyMaxHealth_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.sidKetchum])
                    .withMaxHealth(4)
                    .withHealth(4)
                    .withHand(["c1", "c2"])
            }
            .build()

        // When
        // Then
        let action = GameFeature.Action.preparePlay(.sidKetchum, player: "p1")
        let choices: [Choice] = [
            .init(options: ["c1", "c2", .choicePass], selectionIndex: 0),
            .init(options: ["c2", .choicePass], selectionIndex: 0)
        ]
        await #expect(throws: GameFeature.Error.playerAlreadyMaxHealth("p1")) {
            try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)
        }
    }
}
