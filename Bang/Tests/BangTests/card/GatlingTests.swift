//
//  GatlingTests.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class GatlingTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    
    func test_DamageOthers_IfPlayingGatling() throws {
        // Given
        let c1 = inventory.getCard("gatling", withId: "c1")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(health: 2)
        let p3 = PlayerImpl(health: 3)
        let ctx = GameImpl(players: ["p1": p1, "p2": p2, "p3": p3],
                           playOrder: ["p3", "p1", "p2"],
                           turn: "p1")
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(Play(actor: "p1", card: "c1")),
                .success(ForceDiscard(player: PlayerId("p2"), card: CardSelectHandMatch("missed"))),
                .success(Damage(player: PlayerId("p2"), value: 1)),
                .success(ForceDiscard(player: PlayerId("p3"), card: CardSelectHandMatch("missed"))),
                .success(Damage(player: PlayerId("p3"), value: 1))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_OtherPlayersDoNotLooseHealth_IfPlayingGatling_AndDiscardingMissedCards() throws {
        // Given
        let c1 = inventory.getCard("gatling", withId: "c1")
        let c2 = inventory.getCard("missed", withId: "c2")
        let c3 = inventory.getCard("missed", withId: "c3")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(health: 2, hand: [c2])
        let p3 = PlayerImpl(health: 2, hand: [c3])
        let ctx = GameImpl(players: ["p1": p1, "p2": p2, "p3": p3],
                           playOrder: ["p1", "p2", "p3"],
                           turn: "p1")
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(Play(actor: "p1", card: "c1")),
                .success(ForceDiscard(player: PlayerId("p2"), card: CardSelectHandMatch("missed"))),
                .wait([Choose(player: "p2", label: "c2"),
                       Choose(player: "p2", label: Label.pass)]),
                .input(0),
                .success(Choose(player: "p2", label: "c2")),
                .success(Discard(player: PlayerId("p2"), card: CardId("c2"))),
                .success(ForceDiscard(player: PlayerId("p3"), card: CardSelectHandMatch("missed"))),
                .wait([Choose(player: "p3", label: "c3"),
                       Choose(player: "p3", label: Label.pass)]),
                .input(0),
                .success(Choose(player: "p3", label: "c3")),
                .success(Discard(player: PlayerId("p3"), card: CardId("c3")))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
}
