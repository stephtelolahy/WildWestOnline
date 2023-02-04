//
//  BangTests.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
@testable import GameCards
import GameCore

final class BangTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    private let rule: EngineRule = EngineRuleImpl()
    
    func test_DealDamage_IfPlayingBang() throws {
        // Given
        let c1 = inventory.getCard(.bang, withId: "c1")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"])
        let sut = EngineImpl(ctx, rule: rule)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(ChooseOne([Choose(actor: "p1", label: "p2")])),
                .input(0),
                .success(Choose(actor: "p1", label: "p2")),
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
                           playOrder: ["p1"])
        let sut = EngineImpl(ctx, rule: rule)
        
        createExpectation(
            engine: sut,
            expected: [.error(GameError.noPlayersAt(1))])
        
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
                           played: [.bang])
        let sut = EngineImpl(ctx, rule: rule)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(ChooseOne([Choose(actor: "p1", label: "p2")])),
                .input(0),
                .success(Choose(actor: "p1", label: "p2")),
                .error(GameError.reachedLimitPerTurn(1))
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
                           playOrder: ["p1", "p2"])
        let sut = EngineImpl(ctx, rule: rule)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(ChooseOne([Choose(actor: "p1", label: "p2")])),
                .input(0),
                .success(Choose(actor: "p1", label: "p2")),
                .success(Play(actor: "p1", card: "c1", target: "p2")),
                .success(ForceDiscard(player: PlayerId("p2"), card: CardSelectHandNamed(.missed))),
                .success(ChooseOne([Choose(actor: "p2", label: "c2"),
                                    Choose(actor: "p2", label: Label.pass)])),
                .input(0),
                .success(Choose(actor: "p2", label: "c2")),
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
                           playOrder: ["p1", "p2"])
        let sut = EngineImpl(ctx, rule: rule)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(ChooseOne([Choose(actor: "p1", label: "p2")])),
                .input(0),
                .success(Choose(actor: "p1", label: "p2")),
                .success(Play(actor: "p1", card: "c1", target: "p2")),
                .success(ForceDiscard(player: PlayerId("p2"), card: CardSelectHandNamed(.missed))),
                .success(ChooseOne([Choose(actor: "p2", label: "c2"),
                                    Choose(actor: "p2", label: Label.pass)])),
                .input(1),
                .success(Choose(actor: "p2", label: Label.pass)),
                .success(Damage(player: PlayerId("p2"), value: 1))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
}
