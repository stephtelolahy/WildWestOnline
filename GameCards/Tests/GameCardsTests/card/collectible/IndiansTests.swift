//
//  IndiansTests.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
@testable import GameCards
import GameRules

final class IndiansTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    private let rule: Rule = RuleImpl()
    
    func test_OtherPlayersLooseHealth_IfPlayingIndians_AndNoBangCards() throws {
        // Given
        let c1 = inventory.getCard(.indians, withId: "c1")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl()
        let p3 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2, "p3": p3],
                           playOrder: ["p1", "p2", "p3"])
        let sut = EngineImpl(ctx, rule: rule)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(Play(actor: "p1", card: "c1")),
                .success(ForceDiscard(player: PlayerId("p2"), card: CardSelectHandNamed(.bang))),
                .success(Damage(player: PlayerId("p2"), value: 1)),
                .success(ForceDiscard(player: PlayerId("p3"), card: CardSelectHandNamed(.bang))),
                .success(Damage(player: PlayerId("p3"), value: 1))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_OtherPlayersDoNotLooseHealth_IfPlayingIndians_AndDiscardingBangCards() throws {
        // Given
        let c1 = inventory.getCard(.indians, withId: "c1")
        let c2 = inventory.getCard(.bang, withId: "c2")
        let c3 = inventory.getCard(.bang, withId: "c3")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(hand: [c2])
        let p3 = PlayerImpl(hand: [c3])
        let ctx = GameImpl(players: ["p1": p1, "p2": p2, "p3": p3],
                           playOrder: ["p1", "p2", "p3"])
        let sut = EngineImpl(ctx, rule: rule)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(Play(actor: "p1", card: "c1")),
                .success(ForceDiscard(player: PlayerId("p2"), card: CardSelectHandNamed(.bang))),
                .success(ChooseOne([Choose(actor: "p2", label: "c2"),
                                    Choose(actor: "p2", label: Label.pass)])),
                .input(0),
                .success(Choose(actor: "p2", label: "c2")),
                .success(Discard(player: PlayerId("p2"), card: CardId("c2"))),
                .success(ForceDiscard(player: PlayerId("p3"), card: CardSelectHandNamed(.bang))),
                .success(ChooseOne([Choose(actor: "p3", label: "c3"),
                                    Choose(actor: "p3", label: Label.pass)])),
                .input(0),
                .success(Choose(actor: "p3", label: "c3")),
                .success(Discard(player: PlayerId("p3"), card: CardId("c3")))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
}
