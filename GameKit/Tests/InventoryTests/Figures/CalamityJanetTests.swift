//
//  CalamityJanetTests.swift
//  
//
//  Created by Hugues Telolahy on 20/11/2023.
//

import Game
import Inventory
import XCTest

final class CalamityJanetTests: XCTestCase {
    func test_calamityJanetPlayingMissed_shouldPlayAsBang() throws {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withAttributes([.calamityJanet: 0, .bangsPerTurn: 1, .weapon: 1])
                    .withHand([.missed])
            }
            .withPlayer("p2")
            .build()

        // When
        let action = GameAction.play(.missed, player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .chooseOne(player: "p1", options: [
                "p2": .playImmediate(.missed, target: "p2", player: "p1")
            ]),
            .playImmediate(.missed, target: "p2", player: "p1"),
            .damage(1, player: "p2")
        ])
    }

    func test_calamityJanetPlayingBang_shouldPlayAsMissed() throws {}
}
