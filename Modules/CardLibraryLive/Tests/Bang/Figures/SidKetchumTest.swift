//
//  SidKetchumTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct SidKetchumTest {
    @Test func playing_withTwoCards_shouldDiscardThemAndGainHealth() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withFigure([.sidKetchum])
                    .withMaxHealth(4)
                    .withHealth(1)
                    .withHand(["c1", "c2"])
            }
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.sidKetchum, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.sidKetchum, player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .choose("c2", player: "p1"),
            .discardHand("c2", player: "p1"),
            .heal(1, player: "p1")
        ])
    }

    @Test func playing_withThreeCards_shouldDiscardTwoCardsAndGainHealth() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withFigure([.sidKetchum])
                    .withMaxHealth(4)
                    .withHealth(1)
                    .withHand(["c1", "c2", "c3"])
            }
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.sidKetchum, player: "p1"), state: state)

        #expect(result == [
            .preparePlay(.sidKetchum, player: "p1"),
            .choose("c1", player: "p1"),
            .discardHand("c1", player: "p1"),
            .choose("c2", player: "p1"),
            .discardHand("c2", player: "p1"),
            .heal(1, player: "p1")
        ])
    }

    @Test func playing_withoutCard_shouldThrowError() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withFigure([.sidKetchum])
                    .withMaxHealth(4)
                    .withHealth(1)
            }
            .build()

        await #expect(throws: GameFeature.Error.noChoosableCard([.inHand], player: "p1")) {
            try await dispatchUntilCompleted(.preparePlay(.sidKetchum, player: "p1"), state: state)
        }
    }

    @Test func playing_alreadyMaxHealth_shouldThrowError() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withFigure([.sidKetchum])
                    .withMaxHealth(4)
                    .withHealth(4)
                    .withHand(["c1", "c2"])
            }
            .build()

        await #expect(throws: GameFeature.Error.playerAlreadyMaxHealth("p1")) {
            try await dispatchUntilCompleted(.preparePlay(.sidKetchum, player: "p1"), state: state)
        }
    }
}
