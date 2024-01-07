//
//  JourdonnaisTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Game
import XCTest

final class JourdonnaisTests: XCTestCase {
    func test_JourdonnaisBeingShot_flippedCardIsHearts_shouldCancelShot() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.weapon: 1, .bangsPerTurn: 1])
            }
            .withPlayer("p2") {
                $0.withAbilities([.jourdonnais])
                    .withAttributes([.flippedCards: 1])
            }
            .withDeck(["c1-2♥️"])
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .play(.bang, player: "p1"),
            .discardPlayed(.bang, player: "p1"),
            .chooseOne([
                "p2": .effect(.shoot, ctx: .init(actor: "p1", card: .bang, event: action, target: "p2"))
            ], player: "p1"),
            .draw,
            .cancel(.damage(1, player: "p2"))
        ])
    }
}
