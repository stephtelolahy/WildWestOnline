//
//  PanicTests.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
@testable import GameCards
import GameCore

final class PanicTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    private let rule: EngineRule = EngineRuleImpl()
    
    func test_StealOthersUniqueHandCard_IfPlayingPanic() throws {
        // Given
        let c1 = inventory.getCard(.panic, withId: "c1")
        let c2 = CardImpl(id: "c2")
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
                .success(ChooseOne([Choose(actor: "p1", label: Label.randomHand)])),
                .input(0),
                .success(Choose(actor: "p1", label: Label.randomHand)),
                .success(Steal(player: PlayerId("p1"), target: PlayerId("p2"), card: CardId("c2")))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_StealOthersInPlayCard_IfPlayingPanic() throws {
        // Given
        let c1 = inventory.getCard(.panic, withId: "c1")
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(hand: [c2], inPlay: [c3])
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
                .success(ChooseOne([Choose(actor: "p1", label: "c3"),
                                    Choose(actor: "p1", label: Label.randomHand)])),
                .input(0),
                .success(Choose(actor: "p1", label: "c3")),
                .success(Steal(player: PlayerId("p1"), target: PlayerId("p2"), card: CardId("c3")))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_CannotPlayPanic_IfNoCardsToSteal() throws {
        // Given
        let c1 = inventory.getCard(.panic, withId: "c1")
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
                .error(GameError.playerHasNoCard("p2"))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
}