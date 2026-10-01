//
//  ScopeTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct ScopeTest {
    @Test func play_shouldEquipAndIncreaseMagnifying() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.scope])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.scope, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.scope, player: "p1"),
            .equip(.scope, player: "p1"),
            .increaseMagnifying(1, player: "p1")
        ])
    }

    @Test func discard_shouldDecreaseMagnifying() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.scope])
                    .withMagnifying(1)
            }
            .build()

        let result = try await dispatchUntilCompleted(.discardInPlay(.scope, player: "p1"), state: state)

        #expect(result == [
            .discardInPlay(.scope, player: "p1"),
            .increaseMagnifying(-1, player: "p1")
        ])
    }
}
