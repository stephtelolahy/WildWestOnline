//
//  Test.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 27/12/2024.
//

import Testing
import GameCore

struct AgressiveStrategyTest {
    @Test func evaluatePlayedCard() async throws {
        // Given
        let state = GameState.makeBuilder().build()
        let possibleMoves: [GameAction] = [
            .play("endTurn", player: "p1"),
            .play("panic", player: "p1"),
            .play("bang", player: "p1")
        ]
        let sut = AgressiveStrategy()

        // When
        let bestMove = sut.evaluateBestMove(possibleMoves, state: state)

        // Then
        #expect(bestMove == .play("bang", player: "p1"))
    }

    @Test func evaluateChoosenItem() async throws {
        // Given
        let state = GameState.makeBuilder().build()
        let possibleMoves: [GameAction] = [
            .choose("pass", player: "p1"),
            .choose("bang", player: "p1")
        ]
        let sut = AgressiveStrategy()

        // When
        let bestMove = sut.evaluateBestMove(possibleMoves, state: state)

        // Then
        #expect(bestMove == .choose("bang", player: "p1"))
    }
}
