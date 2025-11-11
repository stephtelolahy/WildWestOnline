//
//  WillyTheKidTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameFeature
@testable import CardResources

struct WillyTheKidTest {
    @Test func willyTheKid_shouldSetNoLimitForBangPerTurn() async throws {
        // Given
        let state = GameSetup.buildGame(
            figures: [.willyTheKid],
            deck: [],
            cards: Cards.all.toDictionary,
            playerAbilities: []
        )

        // When
        let player = state.players.get(.willyTheKid)

        // Then
        #expect(player.playLimitsPerTurn[.bang] == .unlimited)
    }

    @Test func play_noLimitPerTurn_shouldAllowMultipleBang() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withWeapon(1)
                    .withPlayLimitsPerTurn([.bang: .unlimited])
            }
            .withPlayer("p2")
            .withPlayedThisTurn([.bang: 1])
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
}
