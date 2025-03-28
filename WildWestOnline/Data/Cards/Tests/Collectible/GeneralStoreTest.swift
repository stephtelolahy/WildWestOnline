//
//  GeneralStoreTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct GeneralStoreTests {
    @Test func play_threePlayers_shouldAllowEachPlayerToChooseACard() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.generalStore])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.generalStore, player: "p1")
        let choices: [Choice] = [
            .init(options: ["c1", "c2", "c3"], selectionIndex: 0),
            .init(options: ["c2", "c3"], selectionIndex: 1),
            .init(options: ["c2"], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .play(.generalStore, player: "p1"),
            .discover(),
            .discover(),
            .discover(),
            .choose("c1", player: "p1"),
            .drawDiscovered("c1", player: "p1"),
            .choose("c3", player: "p2"),
            .drawDiscovered("c3", player: "p2"),
            .choose("c2", player: "p3"),
            .drawDiscovered("c2", player: "p3")
        ])
    }
}
