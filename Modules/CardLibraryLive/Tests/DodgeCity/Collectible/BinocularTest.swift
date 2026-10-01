//
//  BinocularTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct BinocularTest {
    @Test func play_shouldEquipAndIncreaseMagnifying() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.binocular])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.binocular, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.binocular, player: "p1"),
            .equip(.binocular, player: "p1"),
            .increaseMagnifying(1, player: "p1")
        ])
    }

    @Test func discard_shouldDecreaseMagnifying() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.binocular])
                    .withMagnifying(1)
            }
            .build()

        let result = try await dispatchUntilCompleted(.discardInPlay(.binocular, player: "p1"), state: state)

        #expect(result == [
            .discardInPlay(.binocular, player: "p1"),
            .increaseMagnifying(-1, player: "p1")
        ])
    }
}
