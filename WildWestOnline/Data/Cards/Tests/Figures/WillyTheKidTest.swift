//
//  WillyTheKidTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore
import CardsData

struct WillyTheKidTest {
    @Test func willyTheKid_shouldSetNoLimitForBangPerTurn() async throws {
        // Given
        let state = GameSetupService.buildGame(
            figures: [.willyTheKid],
            deck: [],
            cards: Cards.all,
            playerAbilities: []
        )

        // When
        let player = state.players.get(.willyTheKid)

        // Then
        #expect(player.playLimitPerTurn[.bang] == .infinity)
    }

    @Test func play_noLimitPerTurn_shouldAllowMultipleBang() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withWeapon(1)
                    .withPlayLimitPerTurn([.bang: .infinity])
            }
            .withPlayer("p2")
            .withPlayedThisTurn([.bang: 1])
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2"], selectionIndex: 0)
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
