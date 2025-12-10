//
//  GeneralStoreTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct GeneralStoreTests {
    @Test func play_shouldAllowEachPlayerToChooseACard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.generalStore])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.generalStore, player: "p1")
        let choiceHandler = choiceHandlerWithResponses([
            .init(options: ["c1", "c2", "c3"], selection: "c1"),
            .init(options: ["c2", "c3"], selection: "c3"),
            .init(options: ["c2"], selection: "c2")
        ])
        let result = try await dispatchUntilCompleted(action, state: state, choiceHandler: choiceHandler)

        // Then
        #expect(result == [
            .preparePlay(.generalStore, player: "p1"),
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
