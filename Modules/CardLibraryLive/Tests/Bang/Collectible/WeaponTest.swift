//
//  WeaponTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 17/07/2023.
//

import Testing
import GameCore

struct WeaponTest {
    @Test(arguments: [(String.schofield, 2), (.remington, 3), (.revCarabine, 4), (.winchester, 5)])
    func play_shouldEquipAndSetWeapon(card: String, range: Int) async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [card])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(card, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(card, player: "p1"),
            .equip(card, player: "p1"),
            .setWeapon(range, player: "p1")
        ])
    }

    @Test(arguments: [String.schofield, .remington, .revCarabine, .winchester])
    func discardFromInPlay_shouldResetToDefaultWeapon(card: String) async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", inPlay: [card])
            .build()

        let result = try await dispatchUntilCompleted(.discardInPlay(card, player: "p1"), state: state)

        #expect(result == [
            .discardInPlay(card, player: "p1"),
            .setWeapon(1, player: "p1")
        ])
    }

    @Test(arguments: [String.schofield, .remington, .revCarabine, .winchester])
    func stealFromInPlay_shouldResetToDefaultWeapon(card: String) async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", inPlay: [card])
            .withPlayer("p2")
            .build()

        let action = GameFeature.Action.stealInPlay(card, target: "p1", player: "p2")
        let result = try await dispatchUntilCompleted(action, state: state)

        #expect(result == [
            action,
            .setWeapon(1, player: "p1")
        ])
    }
}
