//
//  TriggerTests.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import GameTesting
@testable import GameCore

class TriggerTests: XCTestCase {

    func test_ApplyCardEffects_IfTriggered() {
        // Given
        let c1 = CardImpl(id: "c1",
                          onTrigger: [EffectMock()])
        let p1: Player = PlayerImpl(abilities: [c1])
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Trigger(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let children = try XCTUnwrap($0.children)
            XCTAssertEqual(children.count, 1)
            assertEqual(children[0], EffectMock())
        }
    }
}