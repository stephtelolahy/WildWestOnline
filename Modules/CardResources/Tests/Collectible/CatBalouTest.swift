//
//  CatBalouTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

import Testing
import GameFeature

struct CatBalouTest {
    @Test func play_targetHavingHandCards_shouldChooseOneHandCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .withPlayer("p2") {
                $0.withHand(["c21"])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.catBalou, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .choose("p2", player: "p1"),
            .choose("hiddenHand-0", player: "p1"),
            .play(.catBalou, player: "p1", target: "p2", card: "c21"),
            .discardHand("c21", player: "p2")
        ])
    }

    @Test func play_targetHavingInPlayCards_shouldChooseOneInPlayCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withDummyCards(["c21"])
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .withPlayer("p2") {
                $0.withInPlay(["c21"])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.catBalou, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .choose("p2", player: "p1"),
            .choose("c21", player: "p1"),
            .play(.catBalou, player: "p1", target: "p2", card: "c21"),
            .discardInPlay("c21", player: "p2")
        ])
    }

    @Test func play_targetHavingHandAndInPlayCards_shouldChooseAnyCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withDummyCards(["c23", "c24"])
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .withPlayer("p2") {
                $0.withHand(["c21", "c22"])
                    .withInPlay(["c23", "c24"])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.catBalou, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .choose("p2", player: "p1"),
            .choose("c23", player: "p1"),
            .play(.catBalou, player: "p1", target: "p2", card: "c23"),
            .discardInPlay("c23", player: "p2")
        ])
    }

    @Test func play_noTarget_shouldThrowError() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withHand([.catBalou])
            }
            .withPlayer("p2")
            .build()

        // When
        // Then
        let action = GameFeature.Action.preparePlay(.catBalou, player: "p1")
        await #expect(throws: GameFeature.Error.noChoosableTarget([.hasCards])) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
