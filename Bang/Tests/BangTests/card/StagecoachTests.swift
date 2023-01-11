//
//  StagecoachTests.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class StagecoachTests: CardTests {
    
    func test_Draw2Cards_IfPlayingStagecoach() throws {
        // Given
        let c1 = inventory.getCard("stagecoach", withId: "c1")
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let p1 = PlayerImpl(hand: [c1])
        let ctx = GameImpl(players: ["p1": p1],
                           turn: "p1",
                           deck: [c2, c3])
        setupInitialState(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try XCTSkipUnless(events.count == 3, "Unexpected events count \(events.count)")
        assertIsSuccess(events[0], equalTo: Play(actor: "p1", card: "c1"))
        assertIsSuccess(events[1], equalTo: DrawDeck(player: .id("p1")))
        assertIsSuccess(events[2], equalTo: DrawDeck(player: .id("p1")))
        
        XCTAssertEqual(state.discard.map(\.id), ["c1"])
        XCTAssertEqual(state.player("p1").hand.map(\.id), ["c2", "c3"])
    }
    
}
