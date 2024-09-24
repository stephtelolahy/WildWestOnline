//
//  SidKetchumTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct SidKetchumTests {
    @Test func playing_SidKetchum_havingTwoCards_shouldDiscardThemAndGainHealth() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.sidKetchum])
                    .withAttributes([.maxHealth: 4])
                    .withHand(["c1", "c2"])
                    .withHealth(1)
            }
            .build()

        // When
        let action = GameAction.preparePlay(.sidKetchum, player: "p1")
        let result = try await dispatch(action, state: state, choose: ["c1", "c2"])

        // Then
        #expect(result == [
            .playAbility(.sidKetchum, player: "p1"),
            .chooseOne(.cardToDiscard, options: ["c1", "c2"], player: "p1"),
            .discardHand("c1", player: "p1"),
            .chooseOne(.cardToDiscard, options: ["c2"], player: "p1"),
            .discardHand("c2", player: "p1"),
            .heal(1, player: "p1")
        ])
    }

    @Test func playing_SidKetchum_havingThreeCards_shouldDiscardTwoCardsAndGainHealth() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.sidKetchum])
                    .withAttributes([.maxHealth: 4])
                    .withHand(["c1", "c2", "c3"])
                    .withHealth(1)
            }
            .build()

        // When
        let action = GameAction.preparePlay(.sidKetchum, player: "p1")
        let result = try await dispatch(action, state: state, choose: ["c1", "c2"])

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
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.sidKetchum])
                    .withAttributes([.maxHealth: 4])
                    .withHealth(1)
            }
            .build()

        // When
        // Then
        let action = GameAction.preparePlay(.sidKetchum, player: "p1")
        await #expect(throws: ArgCard.Error.noCard(.selectHand)) {
            try await dispatch(action, state: state)
        }
    }

    @Test func playing_SidKetchum_alreadyMaxHealth_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withAbilities([.sidKetchum])
                    .withAttributes([.maxHealth: 4])
                    .withHand(["c1", "c2"])
                    .withHealth(4)
            }
            .build()

        // When
        // Then
        let action = GameAction.preparePlay(.sidKetchum, player: "p1")
        await #expect(throws: PlayersState.Error.playerAlreadyMaxHealth("p1")) {
            try await dispatch(action, state: state)
        }
    }
}
