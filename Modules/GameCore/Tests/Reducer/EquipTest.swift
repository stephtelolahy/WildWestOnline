//
//  EquipTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

struct EquipTest {
    @Test func equip_shouldPutCardInPlay() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1", hand: ["c1", "c2"])
            .build()

        let result = try await dispatch(.equip("c1", player: "p1"), state: state)

        #expect(result.players.get("p1").hand == ["c2"])
        #expect(result.players.get("p1").inPlay == ["c1"])
        #expect(result.discard.isEmpty)
    }

    @Test func equip_withCardAlreadyInPlay_shouldThrowError() async throws {
        let state = GameFeature.State.makeBuilder()
            .withPlayer("p1", hand: ["c-1"], inPlay: ["c-2"])
            .build()

        await #expect(throws: GameFeature.Error.cardAlreadyInPlay("c", player: "p1")) {
            try await dispatch(.equip("c-1", player: "p1"), state: state)
        }
    }
}
