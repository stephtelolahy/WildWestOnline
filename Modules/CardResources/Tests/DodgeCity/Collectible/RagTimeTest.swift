//
//  RagTimeTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/11/2025.
//

import Testing
import GameFeature

struct RagTimeTest {
    @Test func play_shouldStealHandCardFromAnyPlayer() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand(["c1", .ragTime])
            }
            .withPlayer("p2") {
                $0.withHand(["c2"])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.ragTime, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.ragTime, player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .choose("p2", player: "p1"),
            .choose("hiddenHand-0", player: "p1"),
            .play(.ragTime, player: "p1", target: "p2", card: "c2"),
            .stealHand("c2", target: "p2", player: "p1"),
        ])
    }

    @Test func play_shouldStealInPlayCardFromAnyPlayer() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand(["c1", .ragTime])
            }
            .withPlayer("p2") {
                $0.withInPlay(["c2"])
            }
            .withDummyCards(["c2"])
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.ragTime, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.ragTime, player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .choose("p2", player: "p1"),
            .choose("c2", player: "p1"),
            .play(.ragTime, player: "p1", target: "p2", card: "c2"),
            .stealInPlay("c2", target: "p2", player: "p1")
        ])
    }

    @Test func play_withoutCostCard_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.ragTime])
            }
            .withPlayer("p2") {
                $0.withHand(["c2"])
            }
            .build()

        // When
        // Assert
        let action = GameFeature.Action.preparePlay(.ragTime, player: "p1")
        await #expect(throws: GameFeature.Error.noChoosableCard([.isFromHand], player: "p1")) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
