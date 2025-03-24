//
//  JourdonnaisTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct JourdonnaisTests {
    @Test(.disabled()) func JourdonnaisBeingShot_flippedCardIsHearts_shouldCancelShot() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.weapon: 1, .missesRequiredForBang: 1, .bangsPerTurn: 1])
            }
            .withPlayer("p2") {
                $0.withAbilities([.jourdonnais])
                    .withAttributes([.flippedCards: 1])
            }
            .withDeck(["c1-2♥️"])
            .build()

        // When
        let action = GameAction.preparePlay(.bang, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2"])

        // Then
        #expect(result == [
            .play(.bang, actor: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .draw
        ])
    }
}
