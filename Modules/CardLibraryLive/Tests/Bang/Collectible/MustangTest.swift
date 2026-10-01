//
//  MustangTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct MustangTest {
    @Test func play_shouldEquipAndIncreaseRemoteness() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.mustang])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.mustang, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.mustang, player: "p1"),
            .equip(.mustang, player: "p1"),
            .increaseRemoteness(1, player: "p1")
        ])
    }

    @Test func discard_shouldDecreaseRemoteness() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.mustang])
                    .withRemoteness(1)
            }
            .build()

        let result = try await dispatchUntilCompleted(.discardInPlay(.mustang, player: "p1"), state: state)

        #expect(result == [
            .discardInPlay(.mustang, player: "p1"),
            .increaseRemoteness(-1, player: "p1")
        ])
    }
}
