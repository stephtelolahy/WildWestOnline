//
//  BangTests.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class BangTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    
    func test_DealDamage_IfPlayingBang() throws {
        // Given
        let c1 = inventory.getCard(.bang, withId: "c1")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           turn: "p1")
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(ChooseOne([Choose(player: "p1", label: "p2")])),
                .input(0),
                .success(Choose(player: "p1", label: "p2")),
                .success(Play(actor: "p1", card: "c1", target: "p2")),
                .success(ForceDiscard(player: PlayerId("p2"), card: CardSelectHandNamed(.missed))),
                .success(Damage(player: PlayerId("p2"), value: 1))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_CannotPlayBang_IfNoPlayerReachable() throws {
        // Given
        let c1 = inventory.getCard(.bang, withId: "c1")
        let p1 = PlayerImpl(hand: [c1])
        let ctx = GameImpl(players: ["p1": p1],
                           playOrder: ["p1"],
                           turn: "p1")
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [.error(.noPlayersAt(1))])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_CannotPlayBang_IfReachedLimitPerTurn() throws {
        // Given
        let c1 = inventory.getCard(.bang, withId: "c1")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           turn: "p1",
                           played: [.bang])
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(ChooseOne([Choose(player: "p1", label: "p2")])),
                .input(0),
                .success(Choose(player: "p1", label: "p2")),
                .error(.reachedLimitPerTurn(1))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_CounterBang_IfPlayingMissed() throws {
        // Given
        let c1 = inventory.getCard(.bang, withId: "c1")
        let c2 = inventory.getCard(.missed, withId: "c2")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(hand: [c2])
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           turn: "p1")
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(ChooseOne([Choose(player: "p1", label: "p2")])),
                .input(0),
                .success(Choose(player: "p1", label: "p2")),
                .success(Play(actor: "p1", card: "c1", target: "p2")),
                .success(ForceDiscard(player: PlayerId("p2"), card: CardSelectHandNamed(.missed))),
                .success(ChooseOne([Choose(player: "p2", label: "c2"),
                                    Choose(player: "p2", label: Label.pass)])),
                .input(0),
                .success(Choose(player: "p2", label: "c2")),
                .success(Discard(player: PlayerId("p2"), card: CardId("c2")))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_DoNotCounterBang_IfMissedNotPlayed() throws {
        // Given
        let c1 = inventory.getCard(.bang, withId: "c1")
        let c2 = inventory.getCard(.missed, withId: "c2")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(hand: [c2])
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           turn: "p1")
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(ChooseOne([Choose(player: "p1", label: "p2")])),
                .input(0),
                .success(Choose(player: "p1", label: "p2")),
                .success(Play(actor: "p1", card: "c1", target: "p2")),
                .success(ForceDiscard(player: PlayerId("p2"), card: CardSelectHandNamed(.missed))),
                .success(ChooseOne([Choose(player: "p2", label: "c2"),
                                    Choose(player: "p2", label: Label.pass)])),
                .input(1),
                .success(Choose(player: "p2", label: Label.pass)),
                .success(Damage(player: PlayerId("p2"), value: 1))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
}
