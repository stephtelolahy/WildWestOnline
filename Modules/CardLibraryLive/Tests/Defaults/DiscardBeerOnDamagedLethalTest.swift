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
        // Given
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

        // When
        let action = GameFeature.Action.damage(1, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state, ignoreError: true)

        // Then
        #expect(result == [
            .damage(1, player: "p1"),
            .choose(.beer, player: "p1"),
            .discardHand(.beer, player: "p1"),
            .heal(1, player: "p1")
        ])
    }

    @Test func beingDamagedLethal_notDiscardingBeer_shouldBeEliminated() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withHealth(1)
                    .withHand([.beer])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameFeature.Action.damage(1, player: "p1")
        let choiceHandler = choiceHandlerWithResponses([
            .init(options: [.beer, .choicePass], selection: .choicePass)
        ])
        let result = try await dispatchUntilCompleted(action, state: state, choiceHandler: choiceHandler)

        // Then
        #expect(result == [
            .damage(1, player: "p1"),
            .choose(.choicePass, player: "p1"),
            .eliminate(player: "p1"),
            .discardHand(.beer, player: "p1")
        ])
    }

    @Test func beingDamagedLethal_withoutBeer_shouldBeEliminated() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withHealth(1)
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        // Then
        let action = GameFeature.Action.damage(1, player: "p1")
        await #expect(throws: GameFeature.Error.noChoosableCard([.named(.beer)], player: "p1")) {
            try await dispatchUntilCompleted(action, state: state)
        }
    }
}
