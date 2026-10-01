//
//  RagTimeTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/11/2025.
//

import Testing
import GameCore

struct RagTimeTest {
    @Test func play_shouldStealHandCardFromAnyPlayer() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: ["c1", .ragTime])
            .withPlayer("p2", hand: ["c2"])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.ragTime, player: "p1"), state: state)

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
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: ["c1", .ragTime])
            .withPlayer("p2", inPlay: ["c2"])
            .withDummyCards(["c2"])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.ragTime, player: "p1"), state: state)

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
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.ragTime])
            .withPlayer("p2", hand: ["c2"])
            .build()

        // Assert
        await #expect(throws: GameFeature.Error.noChoosableCard([.inHand], player: "p1")) {
            try await dispatchUntilCompleted(.preparePlay(.ragTime, player: "p1"), state: state)
        }
    }
}
