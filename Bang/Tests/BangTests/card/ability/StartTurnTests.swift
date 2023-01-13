//
//  StartTurnTests.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class StartTurnTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    
    func test_Draw2Cards_OnSetTurn() {
        // Given
        let c1 = inventory.getCard("startTurn", withId: "c1")
        let p1 = PlayerImpl(abilities: [c1])
        let deck = [CardImpl(), CardImpl()]
        let ctx = GameImpl(players: ["p1": p1],
                           turn: "p1",
                           deck: deck,
                           event: .success(SetTurn(player: PlayerId("p1"))))
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(Play(actor: "p1", card: "c1")),
                .success(DrawDeck(player: PlayerId("p1"))),
                .success(DrawDeck(player: PlayerId("p1")))
            ])
        
        // When
        sut.update()
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
}
