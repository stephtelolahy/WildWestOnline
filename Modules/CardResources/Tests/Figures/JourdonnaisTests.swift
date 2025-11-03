//
//  JourdonnaisTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameFeature
import Testing

struct JourdonnaisTests {
    @Test func JourdonnaisBeingShot_flippedCardIsHearts_shouldCounterShot() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.jourdonnais])
                    .withDrawCards(1)
            }
            .withPlayer("p2") {
                $0.withHand([.bang, "c2"])
                    .withWeapon(1)
                    .withPlayLimitPerTurn([.bang: 1])
            }
            .withDeck(["c1-2♥️"])
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p2")
        let choices: [Choice] = [
            .init(options: ["p1", .choicePass], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)


        // Then
        #expect(result == [
            .choose("p1", player: "p2"),
            .play(.bang, player: "p2", target: "p1"),
            .shoot("p1"),
            .draw(),
            .counterShoot(player: "p1")
        ])
    }
}
