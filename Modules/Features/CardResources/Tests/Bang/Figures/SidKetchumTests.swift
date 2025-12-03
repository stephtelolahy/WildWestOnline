//
//  SidKetchumTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameFeature
import Testing

struct SidKetchumTests {
    @Test func playing_withTwoCards_shouldDiscardThemAndGainHealth() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.sidKetchum])
                    .withMaxHealth(4)
                    .withHealth(1)
                    .withHand(["c1", "c2"])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.sidKetchum, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.sidKetchum, player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .choose("c2", player: "p1"),
            .discardHand("c2", player: "p1"),
            .heal(1, player: "p1")
        ])
    }

    @Test func playing_withThreeCards_shouldDiscardTwoCardsAndGainHealth() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.sidKetchum])
                    .withMaxHealth(4)
                    .withHealth(1)
                    .withHand(["c1", "c2", "c3"])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.sidKetchum, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.sidKetchum, player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .choose("c2", player: "p1"),
            .discardHand("c2", player: "p1"),
            .heal(1, player: "p1")
        ])
    }

    @Test func playing_withoutCard_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.sidKetchum])
                    .withMaxHealth(4)
                    .withHealth(1)
            }
            .build()


        // When
        // Then
        let action = GameFeature.Action.preparePlay(.sidKetchum, player: "p1")
        await #expect(throws: GameFeature.Error.noChoosableCard([.isFromHand], player: "p1")) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }

    @Test func playing_alreadyMaxHealth_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.sidKetchum])
                    .withMaxHealth(4)
                    .withHealth(4)
                    .withHand(["c1", "c2"])
            }
            .build()

        // When
        // Then
        let action = GameFeature.Action.preparePlay(.sidKetchum, player: "p1")
        await #expect(throws: GameFeature.Error.playerAlreadyMaxHealth("p1")) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
