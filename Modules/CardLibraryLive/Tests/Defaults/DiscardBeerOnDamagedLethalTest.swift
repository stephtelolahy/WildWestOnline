//
//  DiscardBeerOnDamagedLethalTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 05/11/2025.
//

import Testing
import GameCore

struct DiscardBeerOnDamagedLethalTest {
    @Test func beingDamagedLethal_discardingBeer_shouldRestoreHealth() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withHealth(1)
                    .withMaxHealth(4)
                    .withHand([.beer])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        let result = try await dispatchUntilCompleted(.damage(1, player: "p1"), state: state, ignoreError: true)

        #expect(result == [
            .damage(1, player: "p1"),
            .choose(.beer, player: "p1"),
            .discardHand(.beer, player: "p1"),
            .heal(1, player: "p1")
        ])
    }

    @Test func beingDamagedLethal_notDiscardingBeer_shouldBeEliminated() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", health: 1, hand: [.beer])
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        let choiceHandler = choiceHandlerWithResponses([
            .init(options: [.beer, .choicePass], selection: .choicePass)
        ])
        let result = try await dispatchUntilCompleted(.damage(1, player: "p1"), state: state, choiceHandler: choiceHandler)

        #expect(result == [
            .damage(1, player: "p1"),
            .choose(.choicePass, player: "p1"),
            .eliminate(player: "p1"),
            .discardHand(.beer, player: "p1")
        ])
    }

    @Test func beingDamagedLethal_withoutBeer_shouldBeEliminated() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1", health: 1)
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        await #expect(throws: GameFeature.Error.noChoosableCard([.named(.beer)], player: "p1")) {
            try await dispatchUntilCompleted(.damage(1, player: "p1"), state: state)
        }
    }
}
