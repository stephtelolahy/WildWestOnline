//
//  SpringfieldTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/11/2025.
//

import Testing
import GameFeature

struct SpringfieldTest {
    @Test func play_shouldShootAtUnlimitedRange() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand(["c1", .springfield])
            }
            .withPlayer("p2") {
                $0.withRemoteness(1)
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.springfield, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.springfield, player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .choose("p2", player: "p1"),
            .play(.springfield, player: "p1", target: "p2"),
            .shoot("p2"),
            .damage(1, player: "p2")
        ])
    }

    @Test func play_withoutCostCard_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.springfield])
            }
            .withPlayer("p2") {
                $0.withRemoteness(1)
            }
            .build()

        // When
        // Assert
        let action = GameFeature.Action.preparePlay(.springfield, player: "p1")
        await #expect(throws: GameFeature.Error.noChoosableCard([.isFromHand], player: "p1")) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
