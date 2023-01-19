//
//  StartTurnTests.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
@testable import Bang
import Combine

final class StartTurnTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    private var disposables: Set<AnyCancellable> = Set()
    
    func test_Draw2Cards_OnSetTurn() {
        // Given
        let c1 = inventory.getCard(.startTurn, withId: "c1")
        let p1 = PlayerImpl(abilities: [c1])
        let p2 = PlayerImpl(abilities: [c1])
        let deck = [CardImpl(), CardImpl()]
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           deck: deck)
        let sut = EngineImpl(ctx, queue: [SetTurn(player: PlayerId("p1"))])
        
        createExpectation(
            engine: sut,
            expected: [
                .success(SetTurn(player: PlayerId("p1"))),
                .success(Trigger(actor: "p1", card: "c1")),
                .success(DrawDeck(player: PlayerId("p1"))),
                .success(DrawDeck(player: PlayerId("p1")))
            ])
        
        // When
        sut.update()
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_DoNothing_IfNoMatchingEvent() {
        // Given
        let c1 = inventory.getCard(.startTurn, withId: "c1")
        let p1 = PlayerImpl(abilities: [c1])
        let deck = [CardImpl(), CardImpl()]
        let ctx = GameImpl(players: ["p1": p1],
                           playOrder: ["p1"],
                           deck: deck)
        let sut = EngineImpl(ctx)
        
        var eventsCount = 0
        sut.state
            .dropFirst()
            .sink { _ in
                eventsCount += 1
            }
            .store(in: &disposables)
        
        // When
        sut.update()
        
        // Assert
        XCTAssertEqual(eventsCount, 0)
    }
    
}
