//
//  DuelTests.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
@testable import GameCards
import GameCore

final class DuelTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    private let rule: EngineRule = EngineRuleImpl()
    
    func test_TargetPlayerLooseHealth_IfPlayingDuel_AndNoBangCards() {
        // Given
        let c1 = inventory.getCard(.duel, withId: "c1")
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
                .success(ChallengeDiscard(player: PlayerId("p2"), challenger: PlayerId("p1"), card: CardSelectHandNamed(.bang))),
                .success(Damage(player: PlayerId("p2"), value: 1))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_TargetPlayersDoNotLooseHealth_IfPlayingDuel_AndDiscarding1BangCards() {
        // Given
        let c1 = inventory.getCard(.duel, withId: "c1")
        let c2 = inventory.getCard(.bang, withId: "c2")
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
                .success(ChallengeDiscard(player: PlayerId("p2"), challenger: PlayerId("p1"), card: CardSelectHandNamed(.bang))),
                .success(ChooseOne([Choose(actor: "p2", label: "c2"),
                                    Choose(actor: "p2", label: Label.pass)])),
                .input(0),
                .success(Choose(actor: "p2", label: "c2")),
                .success(Discard(player: PlayerId("p2"), card: CardId("c2"))),
                .success(ChallengeDiscard(player: PlayerId("p1"), challenger: PlayerId("p2"), card: CardSelectHandNamed(.bang))),
                .success(Damage(player: PlayerId("p1"), value: 1))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_TargetPlayersLooseHealth_IfPlayingDuel_AndDiscarding2BangCards() {
        // Given
        let c1 = inventory.getCard(.duel, withId: "c1")
        let c2 = inventory.getCard(.bang, withId: "c2")
        let c3 = inventory.getCard(.bang, withId: "c3")
        let p1 = PlayerImpl(hand: [c1, c3])
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
                .success(ChallengeDiscard(player: PlayerId("p2"), challenger: PlayerId("p1"), card: CardSelectHandNamed(.bang))),
                .success(ChooseOne([Choose(actor: "p2", label: "c2"),
                                    Choose(actor: "p2", label: Label.pass)])),
                .input(0),
                .success(Choose(actor: "p2", label: "c2")),
                .success(Discard(player: PlayerId("p2"), card: CardId("c2"))),
                .success(ChallengeDiscard(player: PlayerId("p1"), challenger: PlayerId("p2"), card: CardSelectHandNamed(.bang))),
                .success(ChooseOne([Choose(actor: "p1", label: "c3"),
                                    Choose(actor: "p1", label: Label.pass)])),
                .input(0),
                .success(Choose(actor: "p1", label: "c3")),
                .success(Discard(player: PlayerId("p1"), card: CardId("c3"))),
                .success(ChallengeDiscard(player: PlayerId("p2"), challenger: PlayerId("p1"), card: CardSelectHandNamed(.bang))),
                .success(Damage(player: PlayerId("p2"), value: 1))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
}
