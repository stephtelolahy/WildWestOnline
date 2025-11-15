//
//  AgressiveStrategyTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 27/12/2024.
//

import Testing
@testable import GameFeature

struct AgressiveStrategyTest {
    @Test func evaluatePlayedCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder().build()
        let possibleMoves: [GameFeature.Action] = [
            .preparePlay("endTurn", player: "p1"),
            .preparePlay("panic", player: "p1"),
            .preparePlay("bang", player: "p1")
        ]
        let sut = AgressiveStrategy()

        // When
        let bestMove = sut.evaluateBestMove(possibleMoves, state: state)

        // Then
        #expect(bestMove == .preparePlay("bang", player: "p1"))
    }

    @Test func evaluateChoosenItem() async throws {
        // Given
        let state = GameFeature.State.makeBuilder().build()
        let possibleMoves: [GameFeature.Action] = [
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
