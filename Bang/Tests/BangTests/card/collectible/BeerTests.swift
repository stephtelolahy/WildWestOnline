//
//  BeerTests.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

import XCTest
@testable import Bang
import Combine

final class BeerTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    
    func test_GainHealth_IfPlayingBeer() throws {
        // Given
        let ctx = GameImpl.create(
            PlayerImpl(id: "p1")
                .hand(inventory.getCard(.beer, withId: "c1"))
                .health(1)
                .maxHealth(4),
            PlayerImpl(),
            PlayerImpl())
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(Play(actor: "p1", card: "c1")),
                .success(Heal(player: PlayerId("p1"), value: 1))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_ThrowError_IfTwoPlayersLeft() throws {
        // Given
        let ctx = GameImpl.create(
            PlayerImpl(id: "p1")
                .health(1)
                .maxHealth(4)
                .hand(inventory.getCard(.beer, withId: "c1")),
            PlayerImpl())
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [.error(.playersMustBeAtLeast(3))])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_ThrowError_IfMaxHealth() throws {
        // Given
        let ctx = GameImpl.create(
            PlayerImpl(id: "p1")
                .hand(inventory.getCard(.beer, withId: "c1"))
                .health(4)
                .maxHealth(4),
            PlayerImpl(),
            PlayerImpl())
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [.error(.playerAlreadyMaxHealth("p1"))])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
}
