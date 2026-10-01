//
//  HideoutTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct HideoutTest {
    @Test func play_shouldEquipAndIncreaseRemoteness() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.hideout])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.hideout, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.hideout, player: "p1"),
            .equip(.hideout, player: "p1"),
            .increaseRemoteness(1, player: "p1")
        ])
    }

    @Test func discard_shouldDecreaseRemoteness() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.hideout])
                    .withRemoteness(1)
            }
            .build()

        let result = try await dispatchUntilCompleted(.discardInPlay(.hideout, player: "p1"), state: state)

        #expect(result == [
            .discardInPlay(.hideout, player: "p1"),
            .increaseRemoteness(-1, player: "p1")
        ])
    }
}
