//
//  CatBalouTests.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
@testable import GameCards
import GameCore

final class CatBalouTests: XCTestCase {
    
    // TODO: catBalou may discard self's inPlay card, so add new player argument: anyOrSelf
    
    private let inventory: Inventory = InventoryImpl()
    private let rule: EngineRule = EngineRuleImpl()
    
    func test_DiscardOthersUniqueHandCard_IfPlayingCatBalou() throws {
        // Given
        let c1 = inventory.getCard(.catBalou, withId: "c1")
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
                .success(Discard(player: PlayerId("p2"), card: CardId("c2")))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_DiscardOthersRandomHandCard_IfPlayingCatBalou() throws {
        // Given
        let c1 = inventory.getCard(.catBalou, withId: "c1")
        let c2 = CardImpl(id: "c2")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(hand: [c2, c2])
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
                .success(Discard(player: PlayerId("p2"), card: CardId("c2")))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_DiscardOthersInPlayCard_IfPlayingCatBalou() throws {
        // Given
        let c1 = inventory.getCard(.catBalou, withId: "c1")
        let c2 = CardImpl(id: "c2")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(inPlay: [c2])
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
                .success(ChooseOne([Choose(actor: "p1", label: "c2")])),
                .input(0),
                .success(Choose(actor: "p1", label: "c2")),
                .success(Discard(player: PlayerId("p2"), card: CardId("c2")))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_CannotPlayCatBalou_IfNoCardsToDiscard() throws {
        // Given
        let c1 = inventory.getCard(.catBalou, withId: "c1")
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
        
        // Phase: Play
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
}