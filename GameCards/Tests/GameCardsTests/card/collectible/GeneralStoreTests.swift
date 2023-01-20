//
//  GeneralStoreTests.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
@testable import GameCards
import GameRules

final class GeneralStoreTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    private let rule: Rule = RuleImpl()
    
    func test_EachPlayerChooseCard_IfPlayingGeneralStore() throws {
        // Given
        let c1 = inventory.getCard(.generalStore, withId: "c1")
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let c4 = CardImpl(id: "c4")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl()
        let p3 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2, "p3": p3],
                           playOrder: ["p1", "p2", "p3"],
                           deck: [c2, c3, c4])
        let sut = EngineImpl(ctx, rule: rule)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(Play(actor: "p1", card: "c1")),
                .success(Store()),
                .success(Store()),
                .success(Store()),
                .success(ChooseOne([Choose(actor: "p1", label: "c2"),
                                    Choose(actor: "p1", label: "c3"),
                                    Choose(actor: "p1", label: "c4")])),
                .input(0),
                .success(Choose(actor: "p1", label: "c2")),
                .success(DrawStore(player: PlayerId("p1"), card: CardId("c2"))),
                .success(ChooseOne([Choose(actor: "p2", label: "c3"),
                                    Choose(actor: "p2", label: "c4")])),
                .input(1),
                .success(Choose(actor: "p2", label: "c4")),
                .success(DrawStore(player: PlayerId("p2"), card: CardId("c4"))),
                .success(DrawStore(player: PlayerId("p3"), card: CardId("c3")))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_EachPlayerChooseCard_IfPlayingGeneralStore_Case2PlayerS() throws {
        // Given
        let c1 = inventory.getCard(.generalStore, withId: "c1")
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           deck: [c2, c3])
        let sut = EngineImpl(ctx, rule: rule)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(Play(actor: "p1", card: "c1")),
                .success(Store()),
                .success(Store()),
                .success(ChooseOne([Choose(actor: "p1", label: "c2"),
                                    Choose(actor: "p1", label: "c3")])),
                .input(1),
                .success(Choose(actor: "p1", label: "c3")),
                .success(DrawStore(player: PlayerId("p1"), card: CardId("c3"))),
                .success(DrawStore(player: PlayerId("p2"), card: CardId("c2")))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
}
