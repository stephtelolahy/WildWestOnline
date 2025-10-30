//
//  Draw3CardsOnEliminatingTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 30/10/2025.
//

import Testing
import GameCore

struct Draw3CardsOnEliminatingTest {
    @Test func eliminating_shouldDraw2Cards() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAbilities([.draw3CardsOnEliminating])
            }
            .withPlayer("p2") {
                $0.withHealth(1)
                    .withAbilities([.eliminateOnDamageLethal])
            }
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameFeature.Action(name: .damage, sourcePlayer: "p1", targetedPlayer: "p2", amount: 1)
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .damage(1, player: "p2"),
            .eliminate(player: "p2"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1"),
            .drawDeck(player: "p1")
        ])
    }

    @Test func eliminated_withOffenderIsHimself_shouldDoNoting() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHealth(1)
                    .withAbilities([.draw3CardsOnEliminating, .eliminateOnDamageLethal])
            }
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameFeature.Action(name: .damage, sourcePlayer: "p1", targetedPlayer: "p1", amount: 1)
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .damage(1, player: "p1"),
            .eliminate(player: "p1")
        ])
    }
}
