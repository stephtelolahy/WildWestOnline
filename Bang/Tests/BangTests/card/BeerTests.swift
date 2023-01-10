//
//  BeerTests.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang
import Combine

final class BeerTests: XCTestCase {

    private let inventory: Inventory = InventoryImpl()
    private var cancellables = Set<AnyCancellable>()
    
    func test_SuccessFulSequence_IfPlayingBeer() throws {
        // Given
        let c1 = inventory.getCard("beer", withId: "c1")
        let p1 = PlayerImpl(maxHealth: 4, health: 1, hand: [c1])
        let ctx = GameImpl(players: ["p1": p1],
                           playOrder: ["p1", "p2", "p3"],
                           turn: "p1",
                           phase: 2)
        let sut = EngineImpl(ctx: ctx)
        var events: [Result<Effect, GameError>] = []
        sut.state.sink { events.appendNotNil($0.event) }.store(in: &cancellables)

        // When
        sut.input(.play(actor: "p1", card: "c1"))

        // Assert
        try XCTSkipUnless(events.count == 2, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: .play(actor: "p1", card: "c1"))
        assertIsSuccess(events[1], equalTo: .heal(player: .id("p1"), value: 1))

        let op1 = try XCTUnwrap(sut.state.value.players["p1"])
        XCTAssertEqual(op1.hand.map(\.id), [])
        XCTAssertEqual(op1.health, 2)
        XCTAssertEqual(sut.state.value.discard.map(\.id), ["c1"])
    }

}
