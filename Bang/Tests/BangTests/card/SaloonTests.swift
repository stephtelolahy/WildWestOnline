//
//  SaloonTests.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

import XCTest
import Bang

final class SaloonTests: CardTests {

    func test_AllDamagedPlayersGainHealth_IfPlayingSaloon() throws {
        // Given
        let c1 = inventory.getCard("saloon", withId: "c1")
        let p1 = PlayerImpl(maxHealth: 4, health: 1, hand: [c1])
        let p2 = PlayerImpl(maxHealth: 3, health: 2)
        let p3 = PlayerImpl(maxHealth: 3, health: 3)
        let ctx = GameImpl(players: ["p1": p1, "p2": p2, "p3": p3],
                          playOrder: ["p3", "p1", "p2"],
                          turn: "p1")
        setupInitialState(ctx)

        // When
        sut.input(Play(actor: "p1", card: "c1"))

        // Assert
        try XCTSkipUnless(events.count == 3, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Play(actor: "p1", card: "c1"))
        assertIsSuccess(events[1], equalTo: Heal(player: .id("p1"), value: 1))
        assertIsSuccess(events[2], equalTo: Heal(player: .id("p2"), value: 1))

        XCTAssertEqual(state.discard.map(\.id), ["c1"])
        XCTAssertEqual(state.players["p1"]!.hand.map(\.id), [])
        XCTAssertEqual(state.players["p1"]!.health, 2)
        XCTAssertEqual(state.players["p2"]!.health, 3)
        XCTAssertEqual(state.players["p3"]!.health, 3)
    }

    func test_CannotPlaySaloon_IfAllPlayersMaxHealth() throws {
        // Given
        let c1 = inventory.getCard("saloon", withId: "c1")
        let p1 = PlayerImpl(maxHealth: 4, health: 4, hand: [c1])
        let p2 = PlayerImpl(maxHealth: 3, health: 3)
        let p3 = PlayerImpl(maxHealth: 3, health: 3)
        let ctx = GameImpl(players: ["p1": p1, "p2": p2, "p3": p3],
                          playOrder: ["p3", "p1", "p2"],
                          turn: "p1")
        setupInitialState(ctx)

        // When
        sut.input(Play(actor: "p1", card: "c1"))

        // Assert
        try XCTSkipUnless(events.count == 1, "Unexpected events count \(events.count)")
        assertIsFailure(events[0], equalTo: .noPlayerDamaged)
    }
}
