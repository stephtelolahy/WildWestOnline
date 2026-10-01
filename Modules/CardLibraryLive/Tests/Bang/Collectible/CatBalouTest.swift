//
//  CatBalouTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

import Testing
import GameCore

struct CatBalouTest {
    @Test func play_targetHavingHandCards_shouldChooseOneHandCard() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.catBalou])
            .withPlayer("p2", hand: ["c21"])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.catBalou, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.catBalou, player: "p1"),
            .choose("p2", player: "p1"),
            .choose("hiddenHand-0", player: "p1"),
            .play(.catBalou, player: "p1", target: "p2", card: "c21"),
            .discardHand("c21", player: "p2")
        ])
    }

    @Test func play_targetHavingInPlayCards_shouldChooseOneInPlayCard() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withDummyCards(["c21"])
            .withPlayer("p1", hand: [.catBalou])
            .withPlayer("p2", inPlay: ["c21"])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.catBalou, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.catBalou, player: "p1"),
            .choose("p2", player: "p1"),
            .choose("c21", player: "p1"),
            .play(.catBalou, player: "p1", target: "p2", card: "c21"),
            .discardInPlay("c21", player: "p2")
        ])
    }

    @Test func play_targetHavingHandAndInPlayCards_shouldChooseAnyCard() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withDummyCards(["c23", "c24"])
            .withPlayer("p1", hand: [.catBalou])
            .withPlayer("p2", hand: ["c21", "c22"], inPlay: ["c23", "c24"])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.catBalou, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.catBalou, player: "p1"),
            .choose("p2", player: "p1"),
            .choose("c23", player: "p1"),
            .play(.catBalou, player: "p1", target: "p2", card: "c23"),
            .discardInPlay("c23", player: "p2")
        ])
    }

    @Test func play_noTarget_shouldThrowError() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.catBalou])
            .withPlayer("p2")
            .build()

        await #expect(throws: GameFeature.Error.noChoosableTarget([.hasCards])) {
            try await dispatchUntilCompleted(.preparePlay(.catBalou, player: "p1"), state: state)
        }
    }
}
