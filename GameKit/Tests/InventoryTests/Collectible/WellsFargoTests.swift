//
//  WellsFargoTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//
import Game
import XCTest

final class WellsFargoTests: XCTestCase {
    func test_playWellsFargo_shouldDraw3Cards() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.wellsFargo])
            }
            .withPlayer("p2")
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameAction.play(.wellsFargo, player: "p1")
        let (result, _) = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .play(.wellsFargo, player: "p1"),
            .discardPlayed(.wellsFargo, player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }
}
