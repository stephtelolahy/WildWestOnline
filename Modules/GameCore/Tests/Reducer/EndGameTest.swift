//
//  EndGameTest.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 14/11/2024.
//

import Testing
@testable import GameCore

struct EndGameTest {
    @Test func endGame() async throws {
        let state = GameFeature.State.makeBuilder()
            .build()

        let result = try await dispatch(.endGame(), state: state)

        #expect(result.isOver == true)
    }
}
