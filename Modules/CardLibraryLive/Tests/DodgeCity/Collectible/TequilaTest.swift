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
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: ["c1", .tequila])
            .withPlayer("p2") {
                $0.withHealth(1)
                    .withMaxHealth(4)
            }
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.tequila, player: "p1"), state: state)

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
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1", hand: [.tequila])
            .withPlayer("p2") {
                $0.withHealth(1)
                    .withMaxHealth(4)
            }
            .build()

        // Assert
        await #expect(throws: GameFeature.Error.noChoosableCard([.inHand], player: "p1")) {
            try await dispatchUntilCompleted(.preparePlay(.tequila, player: "p1"), state: state)
        }
    }
}
