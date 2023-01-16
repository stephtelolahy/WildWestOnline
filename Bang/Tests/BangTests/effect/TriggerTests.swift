//
//  TriggerTests.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

class TriggerTests: XCTestCase {

    func test_OutputCardEffects_IfPlayed() {
        // Given
        let c1 = CardImpl(id: "c1",
                          onTrigger: [Dummy()])
        let p1: Player = PlayerImpl(abilities: [c1])
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Trigger(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx, playCtx: PlayContextImpl())
        
        // Assert
        assertIsSuccess(result) {
            let children: [EffectNode] = try XCTUnwrap($0.effects)
            XCTAssertEqual(children.count, 1)
            assertEqual(children[0].effect, Dummy())
        }
    }

}
