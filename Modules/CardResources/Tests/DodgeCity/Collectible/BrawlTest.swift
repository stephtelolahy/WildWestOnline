//
//  BrawlTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/11/2025.
//

import Testing
import GameFeature

struct BrawlTest {
    @Test func play_withOthersHavingHandCard_shouldForceThemToDiscardACard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand(["c1", .brawl])
            }
            .withPlayer("p2") {
                $0.withHand(["c2"])
            }
            .withPlayer("p3") {
                $0.withHand(["c3"])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.brawl, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.brawl, player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .play(.brawl, player: "p1", target: "p1"),
            .choose("hiddenHand-0", player: "p1"),
            .discardHand("c2", player: "p2"),
            .choose("hiddenHand-0", player: "p1"),
            .discardHand("c3", player: "p3"),
        ])
    }

    @Test func play_withOthersHavingInPlayCard_shouldForceThemToDiscardACard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand(["c1", .brawl])
            }
            .withPlayer("p2") {
                $0.withInPlay(["c2"])
            }
            .withPlayer("p3") {
                $0.withInPlay(["c3"])
            }
            .withDummyCards(["c2", "c3"])
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.brawl, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.brawl, player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .play(.brawl, player: "p1", target: "p1"),
            .choose("c2", player: "p1"),
            .discardInPlay("c2", player: "p2"),
            .choose("c3", player: "p1"),
            .discardInPlay("c3", player: "p3"),
        ])
    }

    @Test func play_withoutCostCard_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.brawl])
            }
            .withPlayer("p2") {
                $0.withHand(["c2"])
            }
            .build()

        // When
        // Assert
        let action = GameFeature.Action.preparePlay(.brawl, player: "p1")
        await #expect(throws: GameFeature.Error.noChoosableCard([.isFromHand], player: "p1")) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
