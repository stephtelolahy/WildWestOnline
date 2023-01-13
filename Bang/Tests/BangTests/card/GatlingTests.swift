//
//  GatlingTests.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class GatlingTests: EngineTestCase {
    
    func test_DamageOthers_IfPlayingGatling() throws {
        // Given
        let c1 = inventory.getCard("gatling", withId: "c1")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(health: 2)
        let p3 = PlayerImpl(health: 3)
        let ctx = GameImpl(players: ["p1": p1, "p2": p2, "p3": p3],
                           playOrder: ["p3", "p1", "p2"],
                           turn: "p1")
        setupGame(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try assertSequence([
            .success(Play(actor: "p1", card: "c1")),
            .success(ForceDiscard(player: PlayerId("p2"), card: CardSelectHandMatch("missed"))),
            .success(Damage(player: PlayerId("p2"), value: 1)),
            .success(ForceDiscard(player: PlayerId("p3"), card: CardSelectHandMatch("missed"))),
            .success(Damage(player: PlayerId("p3"), value: 1))
        ])
    }
}
