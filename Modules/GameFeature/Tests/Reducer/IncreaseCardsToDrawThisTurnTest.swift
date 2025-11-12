//
//  IncreaseCardsToDrawThisTurnTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 12/11/2025.
//

import Testing
import GameFeature

struct IncreaseCardsToDrawThisTurnTest {
    @Test func increaseCardsToDrawThisTurn_shouldUpdateAttribute() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withCardsToDrawThisTurn(2)
            .build()

        // When
        let action = GameFeature.Action.increaseCardsToDrawThisTurn(1)
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.cardsToDrawThisTurn == 3)
    }
}
