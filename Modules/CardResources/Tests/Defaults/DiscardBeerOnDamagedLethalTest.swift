//
//  DiscardBeerOnDamagedLethalTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 05/11/2025.
//

import Testing
import GameFeature

struct DiscardBeerOnDamagedLethalTest {
    @Test func beingDamagedLethal_discardingBeer_shouldRestoreHealth() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHealth(1)
                    .withMaxHealth(4)
                    .withAbilities([
                        .discardBeerOnDamagedLethal,
                        .eliminateOnDamagedLethal
                    ])
                    .withHand([.beer])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameFeature.Action.damage(1, player: "p1")
        let choices: [Choice] = [
            .init(options: [.beer, .choicePass], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

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
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHealth(1)
                    .withAbilities([
                        .discardBeerOnDamagedLethal,
                        .eliminateOnDamagedLethal
                    ])
                    .withHand([.beer])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .build()

        // When
        let action = GameFeature.Action.damage(1, player: "p1")
        let choices: [Choice] = [
            .init(options: [.beer, .choicePass], selectionIndex: 1)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
            .damage(1, player: "p1"),
            .choose(.choicePass, player: "p1"),
            .eliminate(player: "p1")
        ])
    }
}
