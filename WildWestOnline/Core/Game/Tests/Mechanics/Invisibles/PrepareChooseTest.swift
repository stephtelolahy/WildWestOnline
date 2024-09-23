//
//  PrepareChooseTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 22/09/2024.
//

import Testing
@testable import GameCore

struct PrepareChooseTest {
    @Test func prepareChoose() async throws {
        // Given
        let state = GameState.makeBuilder().build()

        // When
        let action = GameAction.chooseOne(.cardToDraw, options: ["c1", "c2"], player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.sequence.chooseOne == ["p1": .init(type: .cardToDraw, options: ["c1", "c2"])])
    }
}
