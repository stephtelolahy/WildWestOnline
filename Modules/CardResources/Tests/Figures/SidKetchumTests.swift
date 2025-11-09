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
/*
    @Test func playing_SidKetchum_havingThreeCards_shouldDiscardTwoCardsAndGainHealth() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.sidKetchum])
                    .withAttributes([.maxHealth: 4])
                    .withHand(["c1", "c2", "c3"])
                    .withHealth(1)
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.sidKetchum, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["c1", "c2"])

        // Then
        #expect(result == [
            .playAbility(.sidKetchum, player: "p1"),
            .chooseOne(.cardToDiscard, options: ["c1", "c2", "c3"], player: "p1"),
            .discardHand("c1", player: "p1"),
            .chooseOne(.cardToDiscard, options: ["c2", "c3"], player: "p1"),
            .discardHand("c2", player: "p1"),
            .heal(1, player: "p1")
        ])
    }

    @Test func playing_SidKetchum_withoutCard_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.sidKetchum])
                    .withAttributes([.maxHealth: 4])
                    .withHealth(1)
            }
            .build()

        // When
        // Then
        let action = GameFeature.Action.preparePlay(.sidKetchum, player: "p1")
        XCTAssertThrowsError(try awaitAction(action, state: state)) { error in
            #expect(error as? ArgCard.Error == .noCard(.selectHand))
        }
    }

    @Test func playing_SidKetchum_alreadyMaxHealth_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.sidKetchum])
                    .withAttributes([.maxHealth: 4])
                    .withHand(["c1", "c2"])
                    .withHealth(4)
            }
            .build()

        // When
        // Then
        let action = GameFeature.Action.preparePlay(.sidKetchum, player: "p1")
        XCTAssertThrowsError(try awaitAction(action, state: state)) { error in
            #expect(error as? PlayersState.Error == .playerAlreadyMaxHealth("p1"))
        }
    }
 */
}
