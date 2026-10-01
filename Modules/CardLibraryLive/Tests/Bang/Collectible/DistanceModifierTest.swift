//
//  DistanceModifierTest.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameCore

/// Scope and Binocular increase magnifying, Mustang and Hideout increase remoteness
struct DistanceModifierTest {
    @Test(arguments: [String.scope, .binocular])
    func playMagnifyingCard_shouldEquipAndIncreaseMagnifying(card: String) async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [card])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(card, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(card, player: "p1"),
            .equip(card, player: "p1"),
            .increaseMagnifying(1, player: "p1")
        ])
    }

    @Test(arguments: [String.scope, .binocular])
    func discardMagnifyingCard_shouldDecreaseMagnifying(card: String) async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", inPlay: [card]) { $0.withMagnifying(1) }
            .build()

        let result = try await dispatchUntilCompleted(.discardInPlay(card, player: "p1"), state: state)

        #expect(result == [
            .discardInPlay(card, player: "p1"),
            .increaseMagnifying(-1, player: "p1")
        ])
    }

    @Test(arguments: [String.mustang, .hideout])
    func playRemotenessCard_shouldEquipAndIncreaseRemoteness(card: String) async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [card])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(card, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(card, player: "p1"),
            .equip(card, player: "p1"),
            .increaseRemoteness(1, player: "p1")
        ])
    }

    @Test(arguments: [String.mustang, .hideout])
    func discardRemotenessCard_shouldDecreaseRemoteness(card: String) async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", inPlay: [card]) { $0.withRemoteness(1) }
            .build()

        let result = try await dispatchUntilCompleted(.discardInPlay(card, player: "p1"), state: state)

        #expect(result == [
            .discardInPlay(card, player: "p1"),
            .increaseRemoteness(-1, player: "p1")
        ])
    }
}
