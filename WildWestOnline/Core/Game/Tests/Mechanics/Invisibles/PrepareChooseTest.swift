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
        let choice = PendingChoice(
            action: .discard,
            options: ["c1", "c2"],
            children: [:]
        )
        let action = GameAction.chooseOne(choice, player: "p1")
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.chooseOne == ["p1": .init(action: .discard, options: ["c1", "c2"], children: [:])])
    }
}
