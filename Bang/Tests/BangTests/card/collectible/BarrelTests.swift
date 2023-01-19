//
//  BarrelTests.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
// swiftlint:disable identifier_name

import XCTest
@testable import Bang

final class BarrelTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    
    func test_PutInPlay_IfPlayingBarrel() throws {
        // Given
        let c1 = inventory.getCard(.barrel, withId: "c1")
        let p1 = PlayerImpl(hand: [c1])
        let ctx = GameImpl(players: ["p1": p1])
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [.success(Play(actor: "p1", card: "c1"))])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
        XCTAssertEqual(sut.state.value.player("p1").inPlay.map(\.id), ["c1"])
        XCTAssertEqual(sut.state.value.player("p1").hand.map(\.id), [])
    }
    
    func test_CannotHaveMultipleBarrels() {
        // Given
        let ctx = GameImpl.create(
            PlayerImpl(id: "p1")
                .hand(inventory.getCard(.barrel, withId: "c1"))
                .inPlay(inventory.getCard(.barrel, withId: "c2")))
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [.error(.cannotHaveTheSameCardInPlay)])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_CancelShoot_IfFlipCardIsHearts() throws {
        // Given
        let c1 = inventory.getCard(.barrel, withId: "c1")
        let c2 = CardImpl(value: "2♥️")
        let p1 = PlayerImpl(inPlay: [c1])
        let ctx = GameImpl(players: ["p1": p1],
                           deck: [c2])
        let sut = EngineImpl(ctx, queue: [ForceDiscard(player: PlayerId("p1"),
                                                       card: CardSelectHandNamed(.missed),
                                                       otherwise: [Damage(player: PlayerTarget(), value: 1)])])
        
        createExpectation(
            engine: sut,
            expected: [
                .success(ForceDiscard(player: PlayerId("p1"), card: CardSelectHandNamed(.missed))),
                .success(Trigger(actor: "p1", card: "c1")),
                .success(Luck(regex: CardRegex.successfulBarrel)),
                .success(Cancel())
            ])
        
        // When
        sut.update()
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_DealDamage_IfFlipCardIsSpades() throws {
        // Given
        let c1 = inventory.getCard(.barrel, withId: "c1")
        let c2 = CardImpl(value: "A♠️")
        let p1 = PlayerImpl(inPlay: [c1])
        let ctx = GameImpl(players: ["p1": p1],
                           deck: [c2])
        let sut = EngineImpl(ctx, queue: [ForceDiscard(player: PlayerId("p1"),
                                                       card: CardSelectHandNamed(.missed),
                                                       otherwise: [Damage(player: PlayerTarget(), value: 1)])])
        
        createExpectation(
            engine: sut,
            expected: [
                .success(ForceDiscard(player: PlayerId("p1"), card: CardSelectHandNamed(.missed))),
                .success(Trigger(actor: "p1", card: "c1")),
                .success(Luck(regex: CardRegex.successfulBarrel)),
                .success(Damage(player: PlayerId("p1"), value: 1))
            ])
        
        // When
        sut.update()
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_ForceDiscardMissed_IfFlipCardIsSpades() throws {
        // Given
        let c1 = inventory.getCard(.barrel, withId: "c1")
        let c2 = CardImpl(value: "A♠️")
        let c3 = inventory.getCard(.missed, withId: "c3")
        let p1 = PlayerImpl(hand: [c3], inPlay: [c1])
        let ctx = GameImpl(players: ["p1": p1],
                           deck: [c2])
        let sut = EngineImpl(ctx, queue: [ForceDiscard(player: PlayerId("p1"),
                                                       card: CardSelectHandNamed(.missed),
                                                       otherwise: [Damage(player: PlayerTarget(), value: 1)])])
        
        createExpectation(
            engine: sut,
            expected: [
                .success(ForceDiscard(player: PlayerId("p1"), card: CardSelectHandNamed(.missed))),
                .success(Trigger(actor: "p1", card: "c1")),
                .success(Luck(regex: CardRegex.successfulBarrel)),
                .success(ChooseOne([Choose(actor: "p1", label: "c3"),
                                    Choose(actor: "p1", label: Label.pass)])),
                .input(0),
                .success(Choose(actor: "p1", label: "c3")),
                .success(Discard(player: PlayerId("p1"), card: CardId("c3")))
            ])
        
        // When
        sut.update()
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    // TODO test_ResolveBarrelTwice_IfHavingBoth_AbilityAndInPlayCard
}
