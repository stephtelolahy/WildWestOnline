//
//  CatBalouTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

import Testing
import Bang

struct CatBalouTest {
    @Test func playingCatBalou_targetIsOther_havingHandCards_shouldChooseOneHandCard() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .withPlayer("p2") {
                $0.withHand(["c21"])
            }
            .build()

        // When
        let action = GameAction.play(.catBalou, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .play(.catBalou, player: "p1"),
            .discard("c21", player: "p2")
        ])
    }

    @Test func playingCatBalou_targetIsOther_havingInPlayCards_shouldChooseOneInPlayCard() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .withPlayer("p2") {
                $0.withInPlay(["c21"])
            }
            .build()

        // When
        let action = GameAction.play(.catBalou, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .play(.catBalou, player: "p1"),
            .discard("c21", player: "p2")
        ])
    }

    @Test func playingCatBalou_targetIsOther_havingHandAndInPlayCards_shouldChooseAnyCard() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .withPlayer("p2") {
                $0.withHand(["c21", "c22"])
                    .withInPlay(["c23", "c24"])
            }
            .build()

        // When
        let action = GameAction.play(.catBalou, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .play(.catBalou, player: "p1"),
//            .chooseOne(.target, options: ["p2"], player: "p1"),
//            .chooseOne(.cardToDiscard, options: ["c22", "c23", "hiddenHand-0"], player: "p1"),
            .discard("c23", player: "p2")
        ])
    }

    @Test func playingCatBalou_noPlayerAllowed_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .withPlayer("p2")
            .build()

        // When
        // Then
        let action = GameAction.play(.catBalou, player: "p1")
        await #expect(throws: GameError.noChoosableTarget([.havingCard])) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }

    @Test func playingCatBalou_selfHavingHandCards_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.catBalou, "c1", "c2"])
            }
            .withPlayer("p2")
            .build()

        // When
        // Then
        let action = GameAction.play(.catBalou, player: "p1")
        await #expect(throws: GameError.noChoosableTarget([.havingCard])) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
