//
//  TequilaTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/11/2025.
//

import Testing
import GameCore

struct TequilaTest {
    @Test func play_shouldHeal1AnyWoundedPlayer() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand(["c1", .tequila])
            }
            .withPlayer("p2") {
                $0.withHealth(1)
                    .withMaxHealth(4)
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.tequila, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.tequila, player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .choose("p2", player: "p1"),
            .play(.tequila, player: "p1", target: "p2"),
            .heal(1, player: "p2")
        ])
    }

    @Test func play_withoutCostCard_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.tequila])
            }
            .withPlayer("p2") {
                $0.withHealth(1)
                    .withMaxHealth(4)
            }
            .build()

        // When
        // Assert
        let action = GameFeature.Action.preparePlay(.tequila, player: "p1")
        await #expect(throws: GameFeature.Error.noChoosableCard([.isFromHand], player: "p1")) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
