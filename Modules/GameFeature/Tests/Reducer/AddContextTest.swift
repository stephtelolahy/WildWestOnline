//
//  AddContextTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 14/11/2025.
//

import Testing
@testable import GameFeature

struct AddContextTest {
    @Test func addContextCardsPerTurn_shouldUpdateQueuedEffects() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withQueue([.init(name: .draw, contextCardsPerTurn: 2)])
            .build()

        // When
        let action = GameFeature.Action.addContextCardsPerTurn(-1)
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.queue[0].contextCardsPerTurn == 1)
    }

    @Test func addContext_shouldUpdateQueuedEffects() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withQueue([.init(name: .draw)])
            .build()

        // When
        let action = GameFeature.Action.addContextAdditionalMissed(1)
        let result = try await dispatch(action, state: state)

        // Then
        #expect(result.queue[0].contextAdditionalMissed == 1)
    }

}
