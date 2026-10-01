//
//  SchofieldTest.swift
//
//
//  Created by Hugues Telolahy on 17/07/2023.
//

import Testing
import GameCore

struct SchofieldTest {
    @Test func play_shouldSetWeapon() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.schofield])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.schofield, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.schofield, player: "p1"),
            .equip(.schofield, player: "p1"),
            .setWeapon(2, player: "p1")
        ])
    }

    @Test func discardFromInPlay_shouldResetToDefaultWeapon() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.schofield])
                    .withWeapon(2)
            }
            .build()

        let result = try await dispatchUntilCompleted(.discardInPlay(.schofield, player: "p1"), state: state)

        #expect(result == [
            .discardInPlay(.schofield, player: "p1"),
            .setWeapon(1, player: "p1")
        ])
    }

    @Test func stealFromInPlay_shouldResetToDefaultWeapon() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withInPlay([.schofield])
                    .withWeapon(2)
            }
            .withPlayer("p2")
            .build()

        let action = GameFeature.Action.stealInPlay(.schofield, target: "p1", player: "p2")
        let result = try await dispatchUntilCompleted(action, state: state)

        #expect(result == [
            action,
            .setWeapon(1, player: "p1")
        ])
    }
}
