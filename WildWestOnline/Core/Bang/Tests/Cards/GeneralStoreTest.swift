//
//  GeneralStoreTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import Bang

struct GeneralStoreTests {
    @Test func play_threePlayers_shouldAllowEachPlayerToChooseACard() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.generalStore])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameAction.play(.generalStore, player: "p1")
        let choices: [Choice] = [
            .init(options: ["c1", "c2", "c3"], selectionIndex: 0),
            .init(options: ["c2", "c3"], selectionIndex: 0),
            .init(options: ["c3"], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .play(.generalStore, player: "p1"),
            .discover(player: "p1"),
            .discover(player: "p1"),
            .discover(player: "p1"),
            .choose("c1", player: "p1"),
            .drawDiscovered("c1", player: "p1"),
            .choose("c2", player: "p2"),
            .drawDiscovered("c2", player: "p2"),
            .choose("c3", player: "p3"),
            .drawDiscovered("c3", player: "p3")
        ])
    }
}
