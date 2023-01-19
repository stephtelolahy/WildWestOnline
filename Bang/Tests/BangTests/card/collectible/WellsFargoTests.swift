//
//  WellsFargoTests.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
@testable import Bang

final class WellsFargoTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    
    func test_Draw3Cards_IfPlayingWellsFargo() throws {
        // Given
        let c1 = inventory.getCard(.wellsFargo, withId: "c1")
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let c4 = CardImpl(id: "c4")
        let p1 = PlayerImpl(hand: [c1])
        let ctx = GameImpl(players: ["p1": p1],
                           deck: [c2, c3, c4])
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(Play(actor: "p1", card: "c1")),
                .success(DrawDeck(player: PlayerId("p1"))),
                .success(DrawDeck(player: PlayerId("p1"))),
                .success(DrawDeck(player: PlayerId("p1")))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
}
