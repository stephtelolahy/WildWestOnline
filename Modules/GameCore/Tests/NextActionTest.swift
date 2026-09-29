//
//  NextActionTest.swift
//
//  Created by Hugues Telolahy on 29/09/2026.
//

import Testing
import Redux
@testable import GameCore

struct NextActionTest {
    @Test func withQueuedAction_shouldPlayQueuedAction() {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withQueue([.drawDeck(player: "p1")])
            .build()

        // When
        let result = state.nextAction(after: .endGame(), dependencies: .init())

        // Then
        #expect(result == .drawDeck(player: "p1"))
    }

    @Test func withPlayableCards_shouldWaitForPlayer() {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withQueue([.drawDeck(player: "p1")])
            .withPlayable(["c1"], player: "p1")
            .build()

        // When
        let result = state.nextAction(after: .endGame(), dependencies: .init())

        // Then
        #expect(result == nil)
    }

    @Test func withManualPlayer_shouldNotPlayAutoMove() {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withPlayable(["c1"], player: "p1")
            .withPlayMode(["p1": .manual])
            .build()

        // When
        let result = state.autoMove()

        // Then
        #expect(result == nil)
    }
}
