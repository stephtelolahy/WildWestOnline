//
//  JailTests.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//

import XCTest
@testable import GameCards
import GameRules

final class JailTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    private let rule: EngineRule = EngineRuleImpl()
    
    func test_playJailTargettingAnotherPlayer() {
        // Given
        let ctx = GameImpl.create(
            PlayerImpl(id: "p1").hand(inventory.getCard(.jail, withId: "c1")),
            PlayerImpl(id: "p2"),
            PlayerImpl(id: "p3"))
        let sut = EngineImpl(ctx, rule: rule)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(ChooseOne([Choose(actor: "p1", label: "p2"),
                                    Choose(actor: "p1", label: "p3")])),
                .input(0),
                .success(Choose(actor: "p1", label: "p2")),
                .success(Play(actor: "p1", card: "c1", target: "p2"))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_cannotPlayJail_IfTargetAlreadHavetheSameCard() {
        // Given
        let ctx = GameImpl.create(
            PlayerImpl(id: "p1").hand(inventory.getCard(.jail, withId: "c1")),
            PlayerImpl(id: "p2").inPlay(inventory.getCard(.jail, withId: "c2")))
        let sut = EngineImpl(ctx, rule: rule)
        
        createExpectation(
            engine: sut,
            expected: [.error(GameError.cannotHaveTheSameCardInPlay)])
        
        // When
        sut.input(Play(actor: "p1", card: "c1", target: "p2"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_escapeFromJail_IfFlippedCardIsHeart() {
        // Given
        let ctx = GameImpl.create(
            PlayerImpl(id: "p1").inPlay(inventory.getCard(.jail, withId: "c1")))
            .deck(CardImpl(value: "7♥️"))
        let sut = EngineImpl(ctx, queue: [SetTurn(player: PlayerId("p1"))], rule: rule)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(SetTurn(player: PlayerId("p1"))),
                .success(Trigger(actor: "p1", card: "c1")),
                .success(Luck(regex: CardRegex.escapeFromJail)),
                .success(Discard(player: PlayerId("p1"), card: CardId("c1")))
            ])
        
        // When
        sut.update()
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_stayInJail_IfFlippedCardIsNotHeart() {
        // Given
        let ctx = GameImpl.create(
            PlayerImpl(id: "p1").inPlay(inventory.getCard(.jail, withId: "c1")),
            PlayerImpl(id: "p2"))
            .deck(CardImpl(value: "9♦️"))
        let sut = EngineImpl(ctx, queue: [SetTurn(player: PlayerId("p1"))], rule: rule)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(SetTurn(player: PlayerId("p1"))),
                .success(Trigger(actor: "p1", card: "c1")),
                .success(Luck(regex: CardRegex.escapeFromJail)),
                .success(Discard(player: PlayerId("p1"), card: CardId("c1"))),
                .success(SetTurn(player: PlayerId("p2")))
            ])
        
        // When
        sut.update()
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    // TODO: avoid drawing 2 cards at beginning of your turn if stay in jail
}
