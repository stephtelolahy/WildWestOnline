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
            .preparePlay("endTurn", actor: "p1"),
            .preparePlay("panic", actor: "p1"),
            .preparePlay("bang", actor: "p1")
        ]
        let sut = AgressiveStrategy()

        // When
        let bestMove = sut.evaluateBestMove(possibleMoves, state: state)

        // Then
        #expect(bestMove == .preparePlay("bang", actor: "p1"))
    }

    @Test func evaluateChoosenItem() async throws {
        // Given
        let state = GameState.makeBuilder().build()
        let possibleMoves: [GameAction] = [
            .choose("pass", actor: "p1"),
            .choose("bang", actor: "p1")
        ]
        let sut = AgressiveStrategy()

        // When
        let bestMove = sut.evaluateBestMove(possibleMoves, state: state)

        // Then
        #expect(bestMove == .choose("bang", actor: "p1"))
    }
}
